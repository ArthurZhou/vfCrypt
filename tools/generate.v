module main

import os
import crypto.sha256

fn main() {
	psw := 'this is a custom static keyword'
	id := os.input("Enter guid: ")
	println(sha256.hexhash('${psw}|${id}'))
}