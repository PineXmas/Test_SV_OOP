class packet;
    rand int val;
endclass

class sender;
    mailbox mbx;
        
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction //new()

    task run();
        packet pkt;
        for (int i = 0; i<10; i++) begin
            #10;
            pkt = new();
            pkt.randomize();
            this.mbx.put(pkt);
            $display($time, ": send val=%d", pkt.val);    
        end
        
    endtask

endclass //sender

class receiver;
    mailbox mbx;
        
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction //new()

    task run();

        int i;
        int count = 0;
        forever begin
            // this.mbx.get(i);
            count += 1;
            $display($time, ": receive i=%d", i);    

            if (count >= 10) begin
                break;
            end
        end
        
    endtask
endclass //receiver

module test_mailbox;

    sender s_01;
    receiver r_01;
    mailbox mbx;

    initial begin
        s_01 = new(mbx);
        r_01 = new(mbx);

        fork
            s_01.run();
            r_01.run();
        join
        $display("all done");
    end

endmodule