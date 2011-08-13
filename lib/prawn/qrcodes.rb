# This is free and unencumbered software released into the public domain.
# See the `UNLICENSE` file or <http://unlicense.org/> for more details.


require 'prawn'

require 'rqrcode'
require 'securerandom'

module Prawn::QRCodes
	# Adds a QR code to the PDF.
	#
	# @param [String, RQRCode, Numeric, #to_s] code the content of
	#     the QR code
	# @param [Hash] opts the options to generate and to draw the
	#     QR code with
	# @option opts [Boolean] :border draw a border around the QR code
	# @option opts [Symbol] :position horizontal position on the
	#     PDF page: `:left`, `:center`, `:right`
	# @option opts [Symbol] :vposition vertial position on the PDF
	#     page: `:top`, `:center`, `:bottom`
	# @option opts [Array<Numeric, Numeric>] :fit width and height
	#     inside which fit the QR code
	# @option opts [Symbol] :mode the QR mode to use:
	#     `:utf8`, `:ascii`, `:number`, `:kanji`, `:url`
	# @option opts [Symbol] :level the error correction level: `:l`,
	#     `:m`, `:q` or `:h`
	# @option opts [Fixnum] :size force a certain QR module size
	#
	# @example Generating and adding a QR code for "Hello world"
	#
	#	pdf.qrcode "Hello world"
	#
	# @example Same QR code but printed as a centred 200x200 square
	#
	#	pdf.qrcode "Hello world", :fit => [200, 200], :position => :center

	def qrcode(code, opts = {})
		if code.is_a? RQRCode
			code = code
		else
			if code.is_a? Fixnum
				code = code.to_s
				opts[:mode] = :number unless opts[:mode]
			elsif code.is_a? String || code.respond_to(:to_s)
				code = code.to_s
				opts[:mode] = qrcode_best_mode(code) unless opts[:mode]
			else
				msg = code.class.to_s + " cannot be converted to QR code"
				raise ArgumentError.new(msg)
			end

			code = RQRCode::QRCode.new(code, opts)
		end

		qrcode_draw(code, opts)
	end

private

include Prawn::Images # FIXME: remove this hack, see https://github.com/sandal/prawn/issues/266

	def qrcode_draw(qr, opts)
		size = qrcode_default_size(qr)
		w, h = calc_image_dimensions(size, opts)
		x, y = image_position(w, h, opts)

		canvas do
			bounding_box([x, y], :width => w, :height => h) do
				stroke_bounds if opts[:border]

				qr_stamp = "qr_module" + SecureRandom::hex(2)
				qrcode_create_stamp(qr, qr_stamp)

				dot_size = qrcode_dotsize(qr)
				y = bounds.height

				rows = qr.modules
				rows.each do |row|
					x = 0
					row.each do |dark|
						stamp_at(qr_stamp, [x, y]) if dark
						x += dot_size
					end
					y -= dot_size
				end
			end
		end
	end

	def qrcode_default_size(qr)
		size = Struct.new(:width, :height).new

		# FIXME: remove this hack, see https://github.com/sandal/prawn/issues/266
		size = Struct.new(:width, :height, :scaled_width, :scaled_height).new

		len = qr.modules.length
		dot_size = 4 # pt

		size.width = size.height = len * dot_size

		return size
	end

	def qrcode_create_stamp(qr, name)
		size = qrcode_dotsize(qr)
		offset = size / 2
		create_stamp(name) do
			rectangle [0, 0], size, size
			fill
		end
	end

	def qrcode_dotsize(qr)
		return bounds.width / qr.modules.length
	end

	def qrcode_best_mode(string)
		seems_ascii = string.each_byte.all? { |x| x <= 0x7f }
		return seems_ascii ? :ascii : :utf8
	end
end

Prawn::Document.extensions << Prawn::QRCodes

