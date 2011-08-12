prawn-qrcodes
=============

An easy way to add QR codes to PDF files generated with Prawn.


Examples
--------

The easiest way to add QR codes to your Prawn document is to use the
`qrcode` function.

	Prawn::Document.generate("qr-example.pdf") do
		msg = "Hello world, this is a QR code"
		text msg

		qrcode msg
	end

You can pass to `qrcode` two kinds of options: layout options and QR
options.

The layout options allow you to specify how the QR code should be
placed on the PDF page.

	Prawn::Document.generate("qr-big.pdf") do
		msg = "Hello world, this is a QR code"
		text msg

		qrcode msg, :position => :center,
		            :fit => [bounds.height, bounds.width]
	end

The QR options let you change the way the QR codes are generated.

	Prawn::Document.generate("qr-big.pdf") do
		msg = "Hello world, this is a QR code"
		text msg

		qrcode msg, :level => :h
	end

You can mix these options as you like.

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

	gem install prawn-qrcodes


Authors
-------

Original author: Gioele Barabucci <gioele@svario.it>


License
-------

This is free and unencumbered software released into the public domain.
See the `UNLICENSE` file or <http://unlicense.org/> for more details.

