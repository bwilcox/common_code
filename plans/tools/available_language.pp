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
    'ruby' => delete_undef_values($ruby_check.map | $rt | { if $rt.ok {"${rt.target}"} }),
    'perl' => delete_undef_values($perl_check.map | $pt | { if $pt.ok {"${pt.target}"} }),
    'python' => delete_undef_values($python_check.map | $pyt | { if $pyt.ok {"${pyt.target}"} }),
  }

  notice("Installed languages: ${results}")

  # Return an hash of languages available on the target hosts.
  return $results

}
