Matlab and windows batch scripts to mass generate Hydrolight input files with randomised parameters and run them in parallel

In write_HL, choose bounds for the randomisation of initial parameters, or customise it with ranges, etc.. Use either shallow or deep schemes to specify if depth is infinite or has a bottom. If a bottom exists, bottom reflectance values are taken from the excel sheet, or you can rpovide your own.
In run_HL, you will find very basic windows .bat scripts to run HL on these mass produced files, or perform other basic operations. In my scipts I ran 20 workers in parallel, but you can choose otherwise.
In read_HL, I have provided a basic script to calculate remote sensing reflectance (rrs) from the output, which utilisses code written by Eric J. Hochberg (2010).
