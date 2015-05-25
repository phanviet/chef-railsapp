rvm_shell 'create rvm gemset' do
  ruby_string "#{node[:app][:ruby_ver]}"
  code "rvm use #{node[:app][:ruby_ver]}@#{node[:app][:ruby_gemset]} --create --default"
end