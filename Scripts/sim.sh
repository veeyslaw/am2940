cd ..

iverilog -o Outputs/TestBench.vvp -c Scripts/file_list.txt

cd Outputs

rm TestBench.vcd
vvp TestBench.vvp
gtkwave TestBench.vcd &

cd ../Scripts
