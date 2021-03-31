require "gtk3"
require_relative "main.rb"
require "ruby-nfc"

@message ="Please, login with your university card"
app = Gtk::Application.new("org.gtk.example", :flags_none)

label = Gtk::Label.new(@message)
readers = NFC::Reader.all
reader = Reader.new(readers[0])

def scan(reader, label)
  thread = Thread.new {
    label.text = "Waiting for NFC Card"
    css_provider = Gtk::CssProvider.new
    css_provider.load(data: "label {background-color: #2b87e3;}")
    label.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)
    uid = reader.read()
    css_provider = Gtk::CssProvider.new
    css_provider.load(data: "label {background-color: #e32bda;}")

    label.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)
    label.text = "UID: " + uid

    puts
    "UID: " + uid
    label.text = "UID: " + uid
    thread.exit

  }
end


app.signal_connect "activate" do |application|
  # create a new window, and set its title
  window = Gtk::ApplicationWindow.new(application)
  window.set_window_position(Gtk::WindowPosition::CENTER)
  window.set_title("rfid_gtk.rb")
  window.set_border_width(10)
  window.set_default_size(300,75)
  window.set_resizable(false)
  # Here we construct the container that is going pack our objects
  grid = Gtk::Grid.new

  # Pack the container in the window
  window.add(grid)

  # Create label and layoutBox
  layoutBox = Gtk::Box.new(:vertical,10)
  layoutBox.pack_start(label)
  label.set_hexpand(true)
  # css config for label color
  css_provider = Gtk::CssProvider.new
  css_provider.load(data: "label {background-color: #2b87e3;}")
  label.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)

  #Add layoutBox to the window
  grid.attach(layoutBox, 0, 0, 2, 1)



  # create 'clear' button

  button = Gtk::Button.new(:label => "Clear")
  button.signal_connect("clicked") do
    scan(reader, label)
  end
  # css config for button color

  css_provider = Gtk::CssProvider.new
  css_provider.load(data: "button {background-color: white;}\
  button:hover {background-color: #1aff00;}\
  button:active {background-color: red;}"
  )
  button.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)

  #Add button to the window

  grid.attach(button, 0, 1, 2, 1)


  # Now that we are done packing our widgets, we show them all
  # in one go, by calling Gtk::Widget#show_all on the window.

  window.show_all

end


#scan(reader, label)
status = app.run([$0] + ARGV)

puts status
