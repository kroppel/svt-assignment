//gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

class driver;

    //used to count the number of transactions
    int no_transactions;

    //creating virtual interface handle
    virtual vending_intf vending_vif;

    //creating mailbox handle
    mailbox gen2driv;

    //constructor
    function new(virtual vending_intf vending_vif,mailbox gen2driv);
        //getting the interface
        this.vending_vif = vending_vif;
        //getting the mailbox handles from  environment 
        this.gen2driv = gen2driv;
    endfunction

    //Reset task, Reset the Interface signals to default/initial values
    task reset;
        wait(vending_vif.rst);
        $display("--------- [DRIVER] Reset Started ---------");
        wait(!vending_vif.rst);
        $display("--------- [DRIVER] Reset Ended ---------");
    endtask

    //drives the transaction items to interface signals
    task drive;
        transaction trans;
        //get the transacation
        gen2driv.get(trans);
        //wait for the next negedge to inject the inputs into the DUT
        @(negedge vending_vif.clk);

        //inject the inputs
        vending_vif.coin_in=trans.coin_in;
        vending_vif.button_in=trans.button_in;

        no_transactions++;
    endtask


    task main;
        wait(!vending_vif.rst);
        forever
            drive();
   endtask

endclass
