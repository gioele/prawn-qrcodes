
begin
	require 'bones'
rescue LoadError
	abort '### Please install the "bones" gem ###'
end

task :default => 'spec:run'
task 'gem:release' => 'spec:run'

Bones {
	name     'prawn-qrcodes'
	authors  'Gioele Barabucci'
	email    'gioele@svario.it'
	url      'http://prawn-qrcodes.rubyforge.org'

	depend_on 'prawn'
	depend_on 'rqrcode'

	ignore_file '.gitignore'
	history_file 'ChangeLog.md'
}

