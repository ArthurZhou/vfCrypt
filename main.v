import os
import crypto.sha256
import v.pref
import time

fn main() {
	file_name := 'test.zip'  // target file path here
	auto_start := false
	auto_del := false
	duration := 10  // duration to delete file
	embedded_file := $embed_file(file_name, .zlib)

	psw := 'this is a custom static keyword'
	guid := sha256.hexhash(get_guid())
	if os.args.len >= 2 {
		hash := os.args[1]
		if guid != '' {
			println(sha256.hexhash('${psw}|${guid}'))
			if hash == sha256.hexhash('${psw}|${guid}') {
				println('Extracting file...')
				os.write_file(os.join_path('extract', file_name), embedded_file.to_string())!
				println('Starting...')
				if auto_start {
					start(os.abs_path(os.join_path('extract', file_name)))
				}
				if auto_del {
					time.sleep(duration * int(1e+9))
					os.rm(os.abs_path(os.join_path('extract', file_name))) or { return }
				}
			} else {
				println('Key does not match!')
				println('Tips: You can register a key with the following id `${guid}`')
			}
		} else {
			println('Cannot get machine id!')
		}
	} else {
		println('No key detected!')
		println('Tips: You can register a key with the following id `${guid}`')
	}
}

fn start(path string) {
	if pref.get_host_os() == pref.OS.windows {
		os.system('start ${os.abs_path(path)}')
	} else if pref.get_host_os() == pref.OS.macos {
		os.system('open ${os.abs_path(path)}')
	} else if pref.get_host_os() == pref.OS.linux {
		os.system('${os.abs_path(path)}')
	}
}

fn get_guid() string {
	mut command := ''
	if pref.get_host_os() == pref.OS.windows {
		command = 'wmic bios get serialnumber'
	} else if pref.get_host_os() == pref.OS.macos {
		command = 'ioreg -l | grep IOPlatformSerialNumber'
	} else if pref.get_host_os() == pref.OS.linux {
		command = 'sudo dmidecode -t 1 | grep Serial'
	}
	if command != '' {
		guid_cmd := os.execute(command)
		if guid_cmd.exit_code == 0 {
			return guid_cmd.output
		} else {
			return ''
		}
	} else {
		return ''
	}
}
