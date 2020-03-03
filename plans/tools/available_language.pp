# @summary
#   This plan is used to determine what languages are available on 
#   a host.
#
# @example How to use this plan from a command line
#   bolt plan run common_code::tools::available_language \
#     --modulepath ./modules \
#     server='master.test.com' 
#
# @params server
#   The server to check
#

plan common_code::tools::available_language
(
  ARRAY[STRING[1]] $server_list,
)
{
  $ruby_check = run_command('/bin/which ruby', $server_list, '_catch_errors' => true)
  $perl_check = run_command('/bin/which perl', $server_list, '_catch_errors' => true)
  $python_check = run_command('/bin/which python', $server_list, '_catch_errors' => true)

  notice($ruby_check)

  $results = {
    'ruby' => $ruby_check.map | $rt | { if $rt.ok {$rt.target} },
    'perl' => $perl_check.map | $pt | { if $pt.ok {$pt.target} },
    'python' => $python_check.map | $pyt | { if $pyt.ok {$pyt.target} },
  }

  # take out any undef values
  $filtered_results = $results.filter | $k, $v | { $v.each | $m | { unless ($m.length == 0) { $m }}}

  notice("Installed languages: ${filtered_results}")

  # Return an hash of languages available on the target hosts.
  return $filtered_results

}
