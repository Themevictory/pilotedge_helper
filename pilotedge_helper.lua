-- PILOTEDGE helper
-- Simple monitor and transponder to enhance online flying
-- (c) Svilen Vassilev
-- build 2016-05-26
-- Documentation (manual) and latest version at: https://github.com/tarakanbg/pilotedge_helper

--| ----------------------------------|
--|  Customize your preferences here  |
--| ----------------------------------|

-- Completely disables all visual output. Use this to disable 
-- the script without removing it from your "Scripts" folder.
disable_data_display = 0

-- Toggle FPS counter. 1 = Enabled / 0 = Disabled
show_fps = 1

-- Toggle COM radio display. 1 = Enabled / 0 = Disabled
-- Shows the COM radio selected for TRANSMITTING
show_COM_and_frequency = 1

-- Toggle squawk mode display. 1 = Enabled / 0 = Disabled
show_squawk_mode = 1

-- Toggle transponder mini gauge. 1 = Enabled / 0 = Disabled
enable_transponder_minigauge = 1

-- Toggle electrical system fixes for various aircraft models:

-- When set to 1 completely disables all electrical fixes for all aircraft (default 0)
disable_electrical_fixes = 0

-- Enables the coupling of the SMS DHC-2 Beaver alternator switch with
-- X-plane's generator dataref to avoid gradual battery discharge with
-- alternator "on"
enable_sms_dhc2_alternator_fix = 1

--_________________  End of preferences  _________________________--

--________________________________________________________--

--| ----------------------------------|
--|  !! DO NOT EDIT PAST THIS LINE !! |
--| ----------------------------------|

--________________________________________________________--

if disable_electrical_fixes== 0 then

  -- function used for testing
  -- do_every_draw("show_ICAO()")
  -- function show_ICAO()
  --   draw_string(10, 500, AIRCRAFT_FILENAME)
  -- end

  if enable_sms_dhc2_alternator_fix==1 then
    if AIRCRAFT_FILENAME == "SMS_Beaver_Regular.acf" or AIRCRAFT_FILENAME == "SMS_Beaver_Floats.acf" or AIRCRAFT_FILENAME == "SMS_Beaver_Amphib.acf" then
      do_often("determine_dhc2_alternator()")
    end
  end

end

if disable_data_display==0 then

  -- require "radio"

  if show_fps==1 then
    do_every_frame("FPS_count()")
    do_often("FPS_capture()")
    do_every_draw("FPS_draw()")
  end

  if show_COM_and_frequency==1 then
    do_every_frame("determine_radio()")
    do_every_draw("Radio_draw()")
    do_on_mouse_click("radio_mouse_click_events()")
  end

  if show_squawk_mode==1 then
    do_every_frame("determine_transponder()")
    do_every_draw("sq_draw()")
  end

  if enable_transponder_minigauge==1 then
    require "graphics"
    do_every_draw("draw_transponder_gauge()")
    do_on_mouse_click("transponder_mouse_click_events()")
    do_on_mouse_wheel("transponder_wheel_events()")
  end

  fps_pos_x = 5
  fps_pos_y = 5

  radio_position_x = 55
end

--________________________________________________________--
-- FPS counter --
--________________________________________________________--

fps=-1
fps_cnt=0

function FPS_count()
  fps_cnt=fps_cnt+1
end

function FPS_capture()
  fps=fps_cnt
  fps_cnt=0
end

function FPS_draw()
  if(fps>=0 and show_fps==1) then
    if fps<=19  then
      draw_string(fps_pos_x, fps_pos_y, "FPS "..fps, "red")
    elseif fps>=30 then
      draw_string(fps_pos_x, fps_pos_y, "FPS "..fps, "green")
    else
      draw_string(fps_pos_x, fps_pos_y, "FPS "..fps, "yellow")
    end
  end
end

--________________________________________________________--
-- RADIO display --
--________________________________________________________-


function determine_radio()
  dataref("COM1", "sim/cockpit2/radios/actuators/com1_frequency_hz")
  dataref("COM2", "sim/cockpit2/radios/actuators/com2_frequency_hz")
  com1_mhz = string.sub(COM1, 1, 3)
  com1_khz = string.sub(COM1, 4, 5)
  com1_humanized = com1_mhz.."."..com1_khz

  com2_mhz = string.sub(COM2, 1, 3)
  com2_khz = string.sub(COM2, 4, 5)
  com2_humanized = com2_mhz.."."..com2_khz


  dataref("selected_radio", "sim/cockpit2/radios/actuators/audio_com_selection")

  if XPLMFindDataRef("pilotedge/radio/tx_status") ~= nil then
    dataref("tx_on", "pilotedge/radio/tx_status")
  end
  if XPLMFindDataRef("pilotedge/radio/rx_status") ~= nil then
    dataref("rx_on", "pilotedge/radio/rx_status")
  end

  if selected_radio==6 then
    if rx_on == 1 then
      radio_string = "> COM1: "..com1_humanized.." <"
    else
      radio_string = "COM1: "..com1_humanized
    end
    radio_color = "white"
  elseif selected_radio==7 then
    if rx_on == 1 then
      radio_string = "> COM2: "..com2_humanized.." <"
    else
      radio_string = "COM2: "..com2_humanized
    end
    radio_color = "yellow"
  else
    radio_string = "NO RADIO"
    radio_color = "red"
  end
  if tx_on == 1 then
    radio_color = "red"
  end

end

function Radio_draw()
  draw_string(radio_position_x, 5, radio_string, radio_color)
end

function radio_mouse_click_events()
  if MOUSE_STATUS ~= "down" then
    return
  end

  if (MOUSE_X > 55 and MOUSE_X < 135) and (MOUSE_Y > 4 and MOUSE_Y < 30) then
    dataref("transmit_radio", "sim/cockpit2/radios/actuators/audio_com_selection", "writable")
    if transmit_radio==6 then
      transmit_radio = 7
    elseif transmit_radio==7 then
      transmit_radio = 6
    else
      transmit_radio = 6
    end
  end
end

--________________________________________________________--
-- TRANSPONDER mode --
--________________________________________________________-

function determine_transponder()

  dataref("TRANSPONDER_MODE", "sim/cockpit/radios/transponder_mode", "writable")

  if TRANSPONDER_MODE == 0 then
    transponder_color = "red"
    transponder_on = 0
    transponder_string = "-"
  elseif TRANSPONDER_MODE == 1 then
    transponder_color = "yellow"
    transponder_on = 0
    transponder_string = "S"
  else
    transponder_color = "green"
    transponder_on = 1
    transponder_string = "C"
  end
end

function sq_draw()
  if rx_on and rx_on ==1 then
    pos_trans = 160
  else
    pos_trans = 140
  end
  draw_string(pos_trans, 5, "[ "..transponder_string.." ]", transponder_color)
end

--________________________________________________________--
-- TRANSPONDER mini gauge --
--________________________________________________________-

function draw_transponder_gauge()

  dataref("TRANSPONDER_MODE", "sim/cockpit/radios/transponder_mode", "writable")
  dataref("SQUAWK", "sim/cockpit/radios/transponder_code", "writable")

  -- does we have to draw anything?
  if MOUSE_Y > 80 or MOUSE_X < SCREEN_WIDTH - 100 then
    return
  end

  -- init the graphics system
  XPLMSetGraphicsState(0,0,0,1,1,0,0)

  -- draw transparent backgroud
  graphics.set_color(0, 0, 0, 0.5)
  graphics.draw_rectangle(SCREEN_WIDTH - 100, 0, SCREEN_WIDTH, 50)


  -- draw colored switches info
  if TRANSPONDER_MODE == 0 then
    graphics.set_color(1, 0, 0, 0.5)
  elseif TRANSPONDER_MODE == 1 then
    graphics.set_color(1, 1, 0, 0.5)
  else
    graphics.set_color(0, 1, 0, 0.5)
  end
  graphics.draw_rectangle(SCREEN_WIDTH - 100, 0, SCREEN_WIDTH - 92, 50)

  -- ID window
  dataref("IDENT", "sim/cockpit2/radios/indicators/transponder_id")
  if IDENT == 0 then
    graphics.set_color(0, 0, 0, 0.5)
  else
    math.randomseed(os.clock()*100000000000)
    ran = math.random(1, 2)
    if ran == 1 then
      graphics.set_color(0, 1, 0, 0.5)
    else
      graphics.set_color(0, 1, 0, 1)
    end
  end
  graphics.draw_rectangle(SCREEN_WIDTH - 100, 50, SCREEN_WIDTH, 75)
  graphics.set_color(1, 1, 1, 1)
  graphics.set_width(2)
  graphics.draw_line(SCREEN_WIDTH - 100, 51, SCREEN_WIDTH - 100, 75)
  graphics.draw_line(SCREEN_WIDTH - 100, 75, SCREEN_WIDTH - 1, 75)
  graphics.draw_line(SCREEN_WIDTH - 1, 75, SCREEN_WIDTH - 1, 51)
  graphics.draw_line(SCREEN_WIDTH, 51, SCREEN_WIDTH - 100, 51)

  -- draw lines around the hole block
  graphics.set_color(1, 1, 1, 1)
  graphics.set_width(2)
  graphics.draw_line(SCREEN_WIDTH - 100, 1, SCREEN_WIDTH - 100, 50)
  graphics.draw_line(SCREEN_WIDTH - 100, 50, SCREEN_WIDTH - 1, 50)
  graphics.draw_line(SCREEN_WIDTH - 1, 50, SCREEN_WIDTH - 1, 1)
  graphics.draw_line(SCREEN_WIDTH, 1, SCREEN_WIDTH - 100, 1)

  -- draw the info text
  draw_string_Helvetica_10(SCREEN_WIDTH - 80, 38, "SQUAWK")
  draw_string_Helvetica_12(SCREEN_WIDTH - 70, 60, "IDENT")

  sq_len = string.len (SQUAWK)

  if sq_len == 1 then
    digit1 = 0
    digit2 = 0
    digit3 = 0
    digit4 = string.sub(SQUAWK, 1, 1)
  elseif sq_len == 2 then
    digit1 = 0
    digit2 = 0
    digit3 = string.sub(SQUAWK, 1, 1)
    digit4 = string.sub(SQUAWK, 2, 2)
  elseif sq_len == 3 then
    digit1 = 0
    digit2 = string.sub(SQUAWK, 1, 1)
    digit3 = string.sub(SQUAWK, 2, 2)
    digit4 = string.sub(SQUAWK, 3, 3)
  elseif sq_len == 4 then
    digit1 = string.sub(SQUAWK, 1, 1)
    digit2 = string.sub(SQUAWK, 2, 2)
    digit3 = string.sub(SQUAWK, 3, 3)
    digit4 = string.sub(SQUAWK, 4, 4)
  else
    digit1 = 7
    digit2 = 7
    digit3 = 7
  digit4 = 7
  end
  draw_string_Times_Roman_24(SCREEN_WIDTH - 85, 15, digit1)
  draw_string_Times_Roman_24(SCREEN_WIDTH - 65, 15, digit2)
  draw_string_Times_Roman_24(SCREEN_WIDTH - 45, 15, digit3)
  draw_string_Times_Roman_24(SCREEN_WIDTH - 25, 15, digit4)
end

function transponder_mouse_click_events()

  dataref("TRANSPONDER_MODE", "sim/cockpit/radios/transponder_mode", "writable")

  -- we will only react once
  if MOUSE_STATUS ~= "down" then
    return
  end

  if MOUSE_X > SCREEN_WIDTH - 100 and MOUSE_Y < 50 then
    if TRANSPONDER_MODE == 0 then
      TRANSPONDER_MODE = 1
    elseif TRANSPONDER_MODE == 1 then
      TRANSPONDER_MODE = 2
    else
      TRANSPONDER_MODE = 0
    end
    RESUME_MOUSE_CLICK = true
  end

  if MOUSE_X > SCREEN_WIDTH - 100 and (MOUSE_Y > 50 and MOUSE_Y < 75) then
    command_once("sim/transponder/transponder_ident")
  end
end

function transponder_wheel_events()
  dataref("SQUAWK", "sim/cockpit/radios/transponder_code", "writable")

  if MOUSE_Y > 50 or MOUSE_X < SCREEN_WIDTH - 100 then
    return
  end

  --digit 1
  if MOUSE_X > SCREEN_WIDTH - 90 and MOUSE_X < SCREEN_WIDTH - 70 and MOUSE_Y < 50 then
    digit1 = digit1 + MOUSE_WHEEL_CLICKS
    if digit1 > 7 then
      digit1 = 7
    end
    if digit1 < 0 then
      digit1 = 0
    end
  end

  --digit 2
  if MOUSE_X > SCREEN_WIDTH - 70 and MOUSE_X < SCREEN_WIDTH - 50 and MOUSE_Y < 50 then
    digit2 = digit2 + MOUSE_WHEEL_CLICKS
    if digit2 > 7 then
      digit2 = 7
    end
    if digit2 < 0 then
      digit2 = 0
    end
  end

  --digit 3
  if MOUSE_X > SCREEN_WIDTH - 50 and MOUSE_X < SCREEN_WIDTH - 30 and MOUSE_Y < 50 then
    digit3 = digit3 + MOUSE_WHEEL_CLICKS
    if digit3 > 7 then
      digit3 = 7
    end
    if digit3 < 0 then
      digit3 = 0
    end
  end

  --digit 4
  if MOUSE_X > SCREEN_WIDTH - 30 and MOUSE_X < SCREEN_WIDTH - 10 and MOUSE_Y < 50 then
    digit4 = digit4 + MOUSE_WHEEL_CLICKS
    if digit4 > 7 then
      digit4 = 7
    end
    if digit4 < 0 then
      digit4 = 0
    end
  end
  SQUAWK = digit1..digit2..digit3..digit4
  RESUME_MOUSE_WHEEL = true
end

--________________________________________________________--
-- Electrical system fixes --
--________________________________________________________-

-- SMS DHC-2 Beaver Alternator Fix --

function determine_dhc2_alternator()
  if AIRCRAFT_FILENAME == "SMS_Beaver_Regular.acf" or AIRCRAFT_FILENAME == "SMS_Beaver_Floats.acf" or AIRCRAFT_FILENAME == "SMS_Beaver_Amphib.acf" then
    dataref("icao", "sim/aircraft/view/acf_ICAO")
    if XPLMFindDataRef("sms/custom/cdrControlsAlternator") ~= nil then
      dataref("dhc2_alternator", "sms/custom/cdrControlsAlternator")
      dataref("xplane_generator", "sim/cockpit/electrical/generator_on", "writable")
      if dhc2_alternator == 1 then
        xplane_generator = 1
      else
        xplane_generator = 0
      end
    end
  end
end
