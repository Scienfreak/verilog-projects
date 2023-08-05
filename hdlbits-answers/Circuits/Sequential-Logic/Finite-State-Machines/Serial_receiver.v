module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    localparam IDLE = 1'b0;
    localparam RECV = 1'b1;
    
	// detect input
    wire	w_data_0d = in;
    
    // FSM
    reg		r_crnt_state;
    reg		w_next_state;
    
    reg	[3:0]	r_cnt;
    
    always @(posedge clk) begin
        if (reset) begin
            r_crnt_state	<= IDLE;
        end
        else begin
            r_crnt_state	<= w_next_state;
        end
    end
    
    // next state logic
    always @(*) begin
        case (r_crnt_state)
            IDLE: w_next_state = (w_data_0d)? r_crnt_state : RECV;
            RECV: w_next_state = (r_cnt >= 'd8 & w_data_0d)? IDLE : r_crnt_state;
            default: w_next_state = r_crnt_state;
        endcase
    end
    
    // counter
    always @(posedge clk) begin
        if (reset) begin
            r_cnt	<= 'd0;
        end
        else if (r_crnt_state == RECV) begin
            r_cnt	<= (r_cnt < 'd9)? r_cnt + 'd1 : r_cnt;
        end
        else begin
           	r_cnt	<= 'd0; 
        end
    end
    
    // get input
    reg		r_data_1d;
    reg		r_data_2d;
    reg		r_data_3d;
    reg		r_data_4d;
    reg		r_data_5d;
    reg		r_data_6d;
    reg		r_data_7d;
    reg		r_data_8d;
    
    always @(posedge clk) begin
        if (reset) begin
            r_data_1d	<= 'd0;
            r_data_2d	<= 'd0;
            r_data_3d	<= 'd0;
            r_data_4d	<= 'd0;
            r_data_5d	<= 'd0;
            r_data_6d	<= 'd0;
            r_data_7d	<= 'd0;
            r_data_8d	<= 'd0;
        end
        else if( r_crnt_state == RECV ) begin
            r_data_1d	<= w_data_0d;
            r_data_2d	<= r_data_1d;
            r_data_3d	<= r_data_2d;
            r_data_4d	<= r_data_3d;
            r_data_5d	<= r_data_4d;
            r_data_6d	<= r_data_5d;
            r_data_7d	<= r_data_6d;
            r_data_8d	<= r_data_7d;
        end
        else begin
            r_data_1d	<= 'd0;
            r_data_2d	<= 'd0;
            r_data_3d	<= 'd0;
            r_data_4d	<= 'd0;
            r_data_5d	<= 'd0;
            r_data_6d	<= 'd0;
            r_data_7d	<= 'd0;
            r_data_8d	<= 'd0;    
        end
    end
    
	// Done logic
    reg	[7:0]	r_data;
    reg			r_done;
    
    always @(posedge clk) begin
        if (reset) begin
            r_data	<= 'd0;
            r_done	<= 'd0;
        end
        else if( r_crnt_state == RECV ) begin
            if ( (r_cnt == 'd8) & w_data_0d ) begin
                r_data[7]	<= r_data_8d;
                r_data[6]	<= r_data_7d;
                r_data[5]	<= r_data_6d;
                r_data[4]	<= r_data_5d;
                r_data[3]	<= r_data_4d;
                r_data[2]	<= r_data_3d;
                r_data[1]	<= r_data_2d;
                r_data[0]	<= r_data_1d;
                
                r_done		<= 'd1;
            end
            else begin
            	r_data	<= 'd0;
            	r_done	<= 'd0;   
            end
        end
        else begin
            r_data	<= 'd0;
            r_done	<= 'd0;     
        end
    end
    
    // output assign
    assign done	= r_done;

endmodule
