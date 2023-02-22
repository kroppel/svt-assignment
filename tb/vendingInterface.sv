interface vending_intf(input clk, rst);
  
  //declaring the signals
  logic[7:0] coin_in;        // Input coin value in cents
  logic[1:0] button_in;      // Requested beverage (1 = water, 2 = soda)
  int change_out;     // Change in cents
  int beverage_out;   // Provided beverage (1 = water, 2 = soda)

  modport dut (input clk, rst, coin_in, button_in, output change_out, beverage_out);
endinterface
