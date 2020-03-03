# @summary
#   This plan is used to add local hosts file entries to all of the 
#   servers in the list.  This is a stop-gap in case DNS resolution
#   is not available.
#
# @example How to use this plan from a command line
#   bolt plan run common_code::tools::hosts_update \
#     --modulepath ./modules \
#     server_list='["master.test.com"]' \
#
# @params server_list
#   This is an array of FQDNs
#

plan common_code::tools::hosts_update
(
  ARRAY[STRING[1]] $server_list,
)
{

  # Determine what languages are on which hosts
  out::message('Determining languages available on the servers')
  $lang = run_plan('common_code::tools::available_language',
    'server_list' => $server_list
  )
  notice($lang)


  # Manage name resolution via /etc/hosts
  out::message('Updating host file name resolution.')
  $server_list.each |$server| {
    $output = run_command('hostname -I', $server)
    $ip = strip($output.first['stdout'])
    notice("IP for ${server} is ${ip}")

    # Use the right tool for the right job
    #if $lang.member('ruby') {
    #  notice('Found Ruby')
      run_task('common_code::ruby_update_hosts',
        $lang['ruby'],
        'ip'   => $ip,
        'fqdn' => $server,
      )
    #} else {
    #  notice('Did not find ruby')
    #}
  }
}
