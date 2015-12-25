require "thor"
require 'colorize'
require 'progress_bar'
require 'terminal-table'

module Banhpho
	class CLI < Thor

		desc "compress DIR", "compress all png files in DIR"
		def compress(dir)
			abort("Error: command pngquant is not found, please download it from https://pngquant.org/ and put it in your global path") unless command?("pngquant")
			abort("Error: argument '#{dir}' is not a valid directory") unless File.directory?(dir)

			originalSize = 0
			newSize = 0

			imgs = []
			compressInDir(dir) do |f|
				imgs << f
				originalSize += File.size(f)
			end
			bar = ProgressBar.new(imgs.size)
			imgs.each do |f|
				%x(pngquant --force --ext .png --skip-if-larger -- #{f})
				bar.increment!
				newSize += File.size(f)
			end

			count = imgs.size

			if count > 0
				rows = []
				rows << ['Number of files', count]
				rows << ['Original size', prettyFileSize(originalSize)]
				rows << ['New size', prettyFileSize(newSize)]
				rows << ['Compression ratio', "#{(1 - newSize.to_f / originalSize).round(4) * 100}%"]
				report = Terminal::Table.new :title => 'Task completed', :rows => rows
				puts report
			end
		end

		desc "version", "print the version of current release"
		map ['-v', 'v', '--version'] => :version
		def version()
			puts VERSION
		end

		desc "author", "print the author info"
		def author()
			puts 'Created by heartace [love@heartace.me], with ' + '♥'.colorize(:magenta)
		end

		no_commands do
			def compressInDir (dir)
				Dir.foreach(dir) do |item|
					next if item == "." or item == ".."
					path = File.join(dir, item)
					if File.directory?(path)
						compressInDir(path)
						next
					end
					ext = File.extname(path).downcase
					if ext == ".png" then
						fixedPath = path.gsub(/ /, "\\ ")
						yield fixedPath 
					end
				end
			end

			def prettyFileSize(size)
				"#{(size.to_f / 2**20).round(2)} MB"
			end

			def command?(command)
				system("which #{ command} > /dev/null 2>&1")
			end
		end
	end
end
