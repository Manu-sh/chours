#!/usr/bin/ruby

# reopening class
class Time

	def self.elapse_utc(h,m,hh,mm)
		return self.elapse((Time.utc(1970, 1, 1, hh, mm, 0) - Time.utc(1970, 1, 1, h, m, 0)).abs)
	end

	def self.elapse(sec)

		epoch = sec
		hours = (sec / (60*60)).floor
		sec -= hours * (60*60)

		minutes = (sec / 60).floor
		sec -= minutes * 60

		return { hours: hours, minutes: minutes, epoch: epoch }
	end

end

# 10:20 14:30
lc = 0; elapsed = 0
File.open( ARGV[0] || 'stage.txt' ) {|f|

	f.each_line { |line|

		line.strip!
		next if line[0] == '#' || line == ""

		line.split.each_slice(2) {|pair|
			tmp = Time.elapse_utc(*[pair[0].split(':'), pair[1].split(':')].flatten)
			tot = Time.elapse(elapsed += tmp[:epoch])
			puts "#{pair[0]}-#{pair[1]}"
			puts "#{tmp[:hours]}:#{'%02d' % tmp[:minutes]} => (tot: #{tot[:hours]}:#{'%02d' % tot[:minutes]})\n\n"
		}

		puts if ((lc += 1) & 1) === 0
	}

}
