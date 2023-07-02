module main

import os
import crypto.sha256

fn main() {
	psw := 'this is a custom static keyword'
	id := '5c68d4bde976c727b2a95dccea8a6d52c47762370e6483a8a0b37c445a41267d'
	println(sha256.hexhash('${psw}|${id}'))
}