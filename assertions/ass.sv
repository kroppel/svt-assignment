`define vending tbench_top.DUT

checker Ch1(clk,coin_in,button_in,change_out,beverage_out,credit,block_counter,bev_ret);

    //assert property (ch1_clocking.p0_coin_in_increment_credit);
    //assert property (ch1_clocking.p1_retrieve_beverage_no_coin_in);
    //assert property (ch1_clocking.p2);


    clocking ch1_clocking @(posedge clk);

        property p0_coin_in_increment_credit;
            int c;
            int c_i;
            always((coin_in && !block_counter, c = credit, c_i = coin_in) |=> (coin_in && credit == c + c_i + coin_in) || (!coin_in && credit <= c + c_i));
        endproperty

        property p1_retrieve_beverage_no_coin_in;
            // Different results?
            //always(!(coin_in==0 && button_in) || (beverage_out==button_in && bev_ret) || block_counter > 0);
            always(((coin_in==0) && button_in) |=> ((beverage_out==button_in) && bev_ret) || block_counter > 0);
        endproperty

        property p2;
            always((!coin_in && button_in==1 && credit > 30) |=> beverage_out==1);
        endproperty

    endclocking

    
    int p0ATCT=0;
    cover property (ch1_clocking.p0_coin_in_increment_credit) begin
        p0ATCT++;
    end

    int p1ATCT=0;
    cover property (ch1_clocking.p1_retrieve_beverage_no_coin_in) begin
        p1ATCT++;
    end

    int p2ATCT=0;
    cover property (ch1_clocking.p2) begin
        p2ATCT++;    
    end


    final begin
        $display("p0ATCT: %d", p0ATCT);
        $display("p1ATCT: %d", p1ATCT);
        $display("p2ATCT: %d", p2ATCT);
    end

endchecker: Ch1

bind `vending Ch1 ch1_instance(`vending.intf.clk,`vending.intf.coin_in,`vending.intf.button_in,`vending.intf.change_out,`vending.intf.beverage_out, `vending.credit, `vending.block_counter, `vending.bev_ret);
