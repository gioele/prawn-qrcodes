# This is free and unencumbered software released into the public domain.
# See the `UNLICENSE` file or <http://unlicense.org/> for more details.

require 'prawn'

require 'rqrcode'
require 'securerandom'

module Prawn::QRCodes
	def qrcode(qr, opts = {})
		if qr.is_a? String
			qr = RQRCode::QRCode.new(qr)
		end

		qrcode_draw(qr, opts)
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
end

Prawn::Document.extensions << Prawn::QRCodes

