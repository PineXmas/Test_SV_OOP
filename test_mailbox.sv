class packet;
    rand bit [7:0] val;
	rand bit [3:0] delay;
endclass

class sender;
    mailbox mbx;
	packet pkt;
        
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction //new()

    task run();
        
        for (int i = 0; i<10; i++) begin
            pkt = new();
            pkt.randomize();
			
			# pkt.delay;
            mbx.put(pkt);
            $display($time, ": send val=%d, delay=%d", pkt.val, pkt.delay);    
        end
        
    endtask

endclass //sender

class receiver;
    mailbox mbx;
        
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction //new()

    task run();

        packet pkt;
        int count = 0;
        forever begin
            mbx.get(pkt);
            count += 1;
            $display($time, ": receive val=%d", pkt.val);    

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
		mbx = new();
        s_01 = new(mbx);
        r_01 = new(mbx);

        fork
            s_01.run();
            r_01.run();
        join
        $display("all done");
    end

endmodule