class transaction;
  //declaring the transaction items
  rand logic[7:0] coin_in;
  rand logic[1:0] button_in;

  constraint coin_in_constraint {coin_in inside {0, 10, 20, 50, 100, 200};}
  constraint button_in_constraint {button_in inside {0, 1, 2};}

  //post-randomize function, displaying randomized values of items 
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    $display("\t coin_in = %0d",coin_in);
    $display("\t button_in = %0d",button_in);
    $display("-----------------------------------------");
  endfunction
  
  //deep copy method
  function transaction do_copy();
    transaction trans;
    trans = new();
    trans.coin_in  = this.coin_in;
    trans.button_in  = this.button_in;
    return trans;
  endfunction
endclass
