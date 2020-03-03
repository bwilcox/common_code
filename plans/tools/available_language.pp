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
    'perl' => $perl_check.ok,
    'python' => $python_check.ok,
  }

  notice($results)

  $lang = $results.filter |$k,$v| { $v }

  notice("Installed languages: ${lang.keys}")

  # Return an array of languages available on the target host.
  return $lang.keys

}
