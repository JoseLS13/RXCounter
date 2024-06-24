`default_nettype none
// Empty top module

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

  // Your code goes here...
/*ssdec ssdec_inst (.in(pb[3:0]), .enable(pb[4]), .out(ss4[6:0]));
ssdec A (.in(pb[3:0]), .enable(1'b1), .out(ss7[6:0]));
ssdec B (.in(pb[7:4]), .enable(1'b1), .out(ss5[6:0]));
ssdec Cin (.in({1'b0, 1'b0, 1'b0, pb[8]}), .enable(1'b1), .out(ss3[6:0]));
logic Coutbefore;
logic [3:0] S2;
bcdadd1 bcdaddx (.A(pb[3:0]), .B(pb[7:4]), .Cin(pb[8]), .Cout(Coutbefore), .S(S2));
ssdec Cout (.in({1'b0, 1'b0, 1'b0, Coutbefore}), .enable(1'b1), .out(ss1[6:0])); 
ssdec S (.in(S2), .enable(1'b1), .out(ss0[6:0]));*/
//This is from Lab6 1 and 2^^^^^

//enc20to5 inst(.in(pb[19:0]), .out(right[4:0]), .strobe(red));


//counter inst(.clock(pb[0]), .reset(reset), .clear_i(pb[1]), .enable_i(pb[2]), .wrap_i(pb[3]), .max_i({8'b11111111}), .countout({left}), .atmax_o());

logic [3:0] result_shown;
counter inst(.clk(pb[0]), .rst(reset), .enable_i(pb[1]), .wrap_i(1'b1), .max_i(4'b1000), .atmax_o(), .countout(result_shown));
ssdec countout(.in(result_shown), .enable(1'b1), .out(ss7[6:0]));

endmodule
/*
// Add more modules down here...
module ssdec (
    input logic [3:0] in,
    input logic enable,
    output logic [6:0] out
);
    assign out = {enable, in} == 5'b10000 ? 7'b0111111:
    {enable, in} == 5'b10001 ? 7'b0000110: //1
    {enable, in} == 5'b10010 ? 7'b1011011: //2
    {enable, in} == 5'b10011 ? 7'b1001111: //3
    {enable, in} == 5'b10100 ? 7'b1100110: //4
    {enable, in} == 5'b10101 ? 7'b1101101: //5
    {enable, in} == 5'b10110 ? 7'b1111101: //6
    {enable, in} == 5'b10111 ? 7'b0000111: //7
    {enable, in} == 5'b11000 ? 7'b1111111: //8
    {enable, in} == 5'b11001 ? 7'b1100111: //9
    {enable, in} == 5'b11010 ? 7'b1110111: //A or 10
    {enable, in} == 5'b11011 ? 7'b1111100: //b
    {enable, in} == 5'b11100 ? 7'b0111001: //C
    {enable, in} == 5'b11101 ? 7'b1011110: //d
    {enable, in} == 5'b11110 ? 7'b1111001: //E
    {enable, in} == 5'b11111 ? 7'b1110001: //F
    7'b0000000;
endmodule




module bcdadd1 (
  input logic [3:0]A,B,
  input logic Cin,
  output logic [3:0] S,
  output logic Cout
);
logic Coutbefore;
logic [2:0]B2;
logic [3:0]S2;
fa4 bcdadder1 (.A(A), .B(B), .Cin(Cin), .S(S2), .Cout(Coutbefore));

assign B2[1] = (S2[3] & S2[2]) | (S2[3] & S2[1]) | (Coutbefore);
assign B2[2] = (S2[3] & S2[2]) | (S2[3] & S2[1]) | (Coutbefore);

fa4 bcdaddder2 (.A(S2), .B({1'b0, B2[2], B2[1], 1'b0}), .Cin(1'b0), .S(S), .Cout());
assign Cout = (S2[3] & S2[2]) | (S2[3] & S2[1]) | (Coutbefore);
endmodule 

module fa (
  input logic A, B, Cin,
  output logic S, Cout
);
  assign S = ((A ^ B) ^ Cin);
  assign Cout = (A & B) || ((A ^ B) & Cin);

endmodule

module fa4 (
  input logic [3:0]A, B,
  input logic Cin,
  output logic [3:0]S,
  output logic Cout
);
logic [2:0]Cout2;
fa fa1_inst (.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(Cout2[0]));
fa fa2_inst (.A(A[1]), .B(B[1]), .Cin(Cout2[0]), .S(S[1]), .Cout(Cout2[1]));
fa fa3_inst (.A(A[2]), .B(B[2]), .Cin(Cout2[1]), .S(S[2]), .Cout(Cout2[2]));
fa fa4_inst (.A(A[3]), .B(B[3]), .Cin(Cout2[2]), .S(S[3]), .Cout(Cout));
endmodule
//this is from lab 6 1 and 2^^^


module enc20to5 (
  input logic [19:0]in,
  output logic [4:0]out,
  output logic strobe
);
  logic [5:0] i;
 always_comb begin
   out = 0;
   for(i = 0; i < 20; i++)
     if (in[i[4:0]])
       out = i[4:0];
 end

  assign strobe = |in;
endmodule*/

/*
module counter (
input logic clock, reset, 
input logic clear_i, enable_i, wrap_i,
input logic [7:0]max_i,
output logic [7:0]countout,
output logic atmax_o
);

logic [7:0]nextcount;

always_ff @(posedge clock, posedge reset)
  if (reset)
     countout <= 8'b0;
  else
     countout  <= nextcount;

always_comb begin
  if (clear_i == {1'b1})
    nextcount = {8'b0};
  else
    if (enable_i == {1'b1})
      nextcount = {countout + 8'b00000001};
    else
      nextcount = countout;
    if (nextcount == max_i)
      atmax_o = {1'b1};
    else 
      atmax_o = {1'b0};
    if (wrap_i == {1'b1})begin
      if (atmax_o == {1'b1})
        nextcount = {8'b0};
      else
      nextcount = max_i;
    end
end

endmodule
*/

module counter (
    input logic clk, rst, enable_i, clear_i, wrap_i, //enable is connected to the Reg_Start from FSM
    input logic [3:0]max_i,  // We will set the max to 8, or 1000 in binary in the top module
    output logic atmax_o, //the ready signal will be based on this 
    output logic [3:0]countout //this will lead to nowehere, so probably be left open in the top instantuation 
);
    logic [3:0]nextcount;
    always_ff @(posedge clk, posedge rst)
      if (rst)
        countout <= '0;
      else 
        countout <= nextcount; 
    always_comb begin
      if (enable_i == {1'b1})
        nextcount = {countout + 4'b0001};
      else
        nextcount = countout;
      if (nextcount == max_i)
        atmax_o = {1'b1};
      else
        atmax_o = {1'b0};
      if (wrap_i == {1'b1})begin
        if (atmax_o == {1'b1})
          nextcount = {4'b0};
      end
    end 
endmodule

module ssdec (
    input logic [3:0] in,
    input logic enable,
    output logic [6:0] out
);
    assign out = {enable, in} == 5'b10000 ? 7'b0111111:
    {enable, in} == 5'b10001 ? 7'b0000110: //1
    {enable, in} == 5'b10010 ? 7'b1011011: //2
    {enable, in} == 5'b10011 ? 7'b1001111: //3
    {enable, in} == 5'b10100 ? 7'b1100110: //4
    {enable, in} == 5'b10101 ? 7'b1101101: //5
    {enable, in} == 5'b10110 ? 7'b1111101: //6
    {enable, in} == 5'b10111 ? 7'b0000111: //7
    {enable, in} == 5'b11000 ? 7'b1111111: //8
    {enable, in} == 5'b11001 ? 7'b1100111: //9
    {enable, in} == 5'b11010 ? 7'b1110111: //A or 10
    {enable, in} == 5'b11011 ? 7'b1111100: //b
    {enable, in} == 5'b11100 ? 7'b0111001: //C
    {enable, in} == 5'b11101 ? 7'b1011110: //d
    {enable, in} == 5'b11110 ? 7'b1111001: //E
    {enable, in} == 5'b11111 ? 7'b1110001: //F
    7'b0000000;
endmodule

