module vending(vending_intf intf);

// credit in cents
int credit;
// parameter representing time to deliver beverage, N >= 0
int N = 5;
// parameter representing time to deliver change, M >= 0
int M = 5;
// counter for blocking machine for delivering beverage/change
int block_counter;
// bit to check if user retrieved beverage (to decide if change is returned)
logic bev_ret;

logic[4:0] local_change_out;
logic[1:0] local_beverage_out;

always_ff @(posedge intf.clk or intf.rst) begin

    if(intf.rst) begin
        credit <= 0;
        block_counter <= 0;
        bev_ret <= 0;
        local_change_out <= 0;
        local_beverage_out <= 0;
    end else begin
        // check if blocked (due to beverage / change output) 
        if(block_counter) begin
            block_counter <= block_counter - 1;
        end else begin
            if (bev_ret && (credit < 30)) begin
                local_change_out <= credit;
                credit <= 0;
                block_counter <= M;
                bev_ret <= 0;
            end else begin
                local_change_out <= 0;
                // user inserted coin
                if(intf.coin_in) begin
                    // switch statement for type of coin
                    case (intf.coin_in)
                        10:
                            credit <= credit + 10;
                        20:
                            credit <= credit + 20;
                        50:
                            credit <= credit + 50;
                        100:
                            credit <= credit + 100;
                        200:
                            credit <= credit + 200;
                    endcase
                end else begin
                    // user pressed button
                    if (intf.button_in) begin
                        case (intf.button_in)
                            1: begin
                                if (credit > 30) begin
                                    credit <= credit - 30;
                                    local_beverage_out <= 1;
                                    block_counter <= N;
                                    bev_ret <= 1;
                                end
                            end
                            2: begin
                                if (credit > 50) begin
                                    credit <= credit - 50;
                                    local_beverage_out <= 2;
                                    block_counter <= N;
                                    bev_ret <= 1;
                                end
                            end
                        endcase
                    end else begin
                        local_beverage_out <= 0;
                    end
                end
            end
        end
    end
end

assign intf.change_out = local_change_out;
assign intf.beverage_out = local_beverage_out;

endmodule
