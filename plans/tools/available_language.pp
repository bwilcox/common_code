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
  STRING[1] $server,
)
{
  $ruby_check = run_command('/bin/which ruby', $server, '_catch_errors' => true)
  $perl_check = run_command('/bin/which perl', $server, '_catch_errors' => true)
  $python_check = run_command('/bin/which python', $server, '_catch_errors' => true)

  $results = {
    'ruby' => $ruby_check.ok,
    'perl' => $perl_check.ok,
    'python' => $python_check.ok,
  }

  $lang = $results.filter |$k,$v| { $v }

  notice("Installed languages: ${lang.keys}")

  # Return an array of languages available on the target host.
  return $lang.keys

}
