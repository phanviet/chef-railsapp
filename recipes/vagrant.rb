ruby_block "Fixing vagrant nameserver" do
  block do
    line = 'nameserver 8.8.8.8'

    file = Chef::Util::FileEdit.new('/etc/resolv.conf')
    file.search_file_delete(/nameserver 10.0.2.3/)
    file.insert_line_if_no_match(/#{line}/, line)
    file.write_file
  end
end