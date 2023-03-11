`define vending tbench_top.DUT

checker Ch1(clk,coin_in,button_in,change_out,beverage_out,credit,block_counter,bev_ret);

    assert property (ch1_clocking.p0_coin_in_increment_credit);
    assert property (ch1_clocking.p1_retrieve_beverage_decrease_credit);
    assert property (ch1_clocking.p2_retrieve_beverage_water_set_output);
    assert property (ch1_clocking.p3_ignore_request_water_credit_insufficient);
    assert property (ch1_clocking.p4_retrieve_beverage_block_machine);

    clocking ch1_clocking @(posedge clk);

        property p0_coin_in_increment_credit;
            int c = 0;
            int c_i = 0;
            (coin_in && !block_counter, c = credit, c_i = coin_in) |=> (credit == c + c_i);

        endproperty

        property p1_retrieve_beverage_decrease_credit;
            int c = 0;
            (!coin_in && button_in && !block_counter && credit > 50, c = credit) |=> (credit < c);
        endproperty

        property p2_retrieve_beverage_water_set_output;
            (!coin_in && button_in == 1 && credit > 30 && !block_counter) |=> beverage_out == 1;
        endproperty

        property p3_ignore_request_water_credit_insufficient;
            (!coin_in && button_in && credit < 30 && !block_counter) |=> beverage_out == 0;
        endproperty

        property p4_retrieve_beverage_block_machine;
            (!coin_in && button_in && !block_counter && credit > 50) |=> block_counter;
        endproperty

    endclocking

    
    int p0ATCT=0;
    cover property (ch1_clocking.p0_coin_in_increment_credit) begin
        p0ATCT++;
    end

    int p1ATCT=0;
    cover property (ch1_clocking.p1_retrieve_beverage_decrease_credit) begin
        p1ATCT++;
    end

    int p2ATCT=0;
    cover property (ch1_clocking.p2_retrieve_beverage_water_set_output) begin
        p2ATCT++;    
    end

    int p3ATCT=0;
    cover property (ch1_clocking.p3_ignore_request_water_credit_insufficient) begin
        p3ATCT++;    
    end

    int p4ATCT=0;
    cover property (ch1_clocking.p4_retrieve_beverage_block_machine) begin
        p4ATCT++;    
    end

    final begin
        $display("p0ATCT: %d", p0ATCT);
        $display("p1ATCT: %d", p1ATCT);
        $display("p2ATCT: %d", p2ATCT);
        $display("p3ATCT: %d", p3ATCT);
        $display("p4ATCT: %d", p4ATCT);
    end

endchecker: Ch1

bind `vending Ch1 ch1_instance(`vending.intf.clk,`vending.intf.coin_in,`vending.intf.button_in,`vending.intf.change_out,`vending.intf.beverage_out, `vending.credit, `vending.block_counter, `vending.bev_ret);
