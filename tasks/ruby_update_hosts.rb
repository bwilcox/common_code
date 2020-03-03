# @summary
#   This plan is used to add local hosts file entries to all of the 
#   servers in the list.  This is a stop-gap in case DNS resolution
#   is not available.
#
# @example How to use this plan from a command line
#   bolt plan run common_code::hosts_update \
#     --modulepath ./modules \
#     server_list='["master.test.com"]' 
#
# @params server_list
#   This is an array of FQDNs
#

plan common_code::tools::hosts_update
(
  ARRAY[STRING[1]] $server_list,
)
{

  # Manage name resolution via /etc/hosts
  out::message('Updating host file name resolution.')
  $server_list.each |$server| {
    $output = run_command('hostname -I', $server)

    # Get the IP for the server
    $ip = strip($output.first['stdout'])
    notice("IP for ${server} is ${ip}")

    run_task('nike_pe_infra::update_hosts',
      $server_list,
      'ip'   => $ip,
      'fqdn' => $server,
    )
  }
}
