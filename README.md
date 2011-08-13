prawn-qrcodes
=============

Add QR codes to PDF files generated with Prawn.

Features
--------

`prawn-qrcodes` is little Prawn extension that allow you to generate
and add QR codes to PDF files. It can generate QR codes from

* UTF-8 strings,
* ASCII strings,
* Kanji strings,
* URIs,
* integer numbers.

Examples
--------

The easiest way to add QR codes to your Prawn document is to use the
`qrcode` function.

	require 'prawn/qrcodes'

	Prawn::Document.generate("qr-example.pdf") do
		msg = "Hello world, this is a QR code"
		text msg

		qrcode msg
	end

You can pass to `qrcode` two kinds of options: layout options and QR
options.

The layout options allow you to specify how the QR code should be
placed on the PDF page.

	require 'prawn/qrcodes'

	Prawn::Document.generate("qr-big.pdf") do
		msg = "Hello world, this is a QR code"
		text msg

		qrcode msg, :position => :center,
		            :fit => [bounds.height, bounds.width]
	end

The QR options let you change the way the QR codes are generated.

	require 'prawn/qrcodes'

	Prawn::Document.generate("qr-big.pdf") do
		msg = "Hello world, this is a QR code"
		text msg

		qrcode msg, :level => :h
	end

You can mix these options as you like.

	require 'prawn/qrcodes'

	Prawn::Document.generate("qr-big.pdf") do
		msg = "Hello world, this is a QR code"
		text msg

		qrcode msg, :level => :h, :position => :center
	end


Requirements
------------

`prawn-qrcodes` uses the `rqrcode` library for the generation of QR
codes.


Installation
------------

`prawn-qrcodes` is available on RubyGems.

	$ gem install prawn-qrcodes

Once it has been installed, you can include it in your application with:

	require 'prawn/qrcodes'


Authors
-------

Original author: Gioele Barabucci <gioele@svario.it>


License
-------

This is free and unencumbered software released into the public domain.
See the `UNLICENSE` file or <http://unlicense.org/> for more details.

