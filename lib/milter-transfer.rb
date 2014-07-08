require "milter/client"

class MilterTransfer < Milter::ClientSession

  EMERGENCY_ADDRESSES = [
    "emergency@example.com",
    "root@example.com",
  ]


  def initialize(context, options)
    super(context)
  end

  def header(name, value)
    if name =~ /\ASubject/i
      @need_transfer = true if value =~ /EMERGENCY/
    end
  end

  def end_of_message
    if @need_transfer
      EMERGENCY_ADDRESSES.each do |address|
        add_recipient(address)
      end
    end
  end

  def reset
    @need_transfer = false
  end
end
