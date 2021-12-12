use File::Basename;


my %hash;
open IN, "Fig3A_B_subtype_cluster_demo.txt";
while ($line=<IN>){
	chomp $line;
	my @tmp=split(/\t/,$line);
	$hash{$tmp[1]}=$tmp[0];
	
}
close IN;

my @files1=`find ./ -name "GSVA*ST_P1*txt"`;
chomp @files1;

my @files2=`find ./ -name "GSVA*ST_P5*txt"`;
chomp @files2;

my @files3=`find ./ -name "GSVA*ST_P6*txt"`;
chomp @files3;

my @files4=`find ./ -name "GSVA*ST_P7*txt"`;
chomp @files4;

my @files5=`find ./ -name "GSVA*ST_P8*txt"`;
chomp @files5;

my @files= (@files1, @files2, @files3, @files4, @files5);

print "Sample\tSubtype\tCluster\tSpot\tPathway\tScore\n";

foreach my $infile (@files){
	
	my $sample=basename $infile;
	$sample=~s/GSVA_//;
	$sample=~s/_KEGG\.txt//;
	$sample=~s/_Reactome\.txt//;
	$sample=~s/_Hallmark\.txt//;
	
	my %cluster;
	open IN, "stdata_meta.txt";
	while ($line=<IN>){
		chomp $line;
		next if ($line=~/cell_type/);
		
		my @tmp=split(/\t/,$line);
		$cluster{$tmp[0]}=$tmp[1];
		
		
	}
	close IN;
	
	my %header;
	my $i=1;
	open IN, "$infile";
	while ($line=<IN>){
		chomp $line;
		
		my @tmp=split(/\t/,$line);
		
		if ($i == 1){
			for(my $j=0; $j<=$#tmp;$j++){
				my $new_j=$j+1;
				$header{$new_j}=$tmp[$j];
			}
		}else{
			my $pathway=$tmp[0];
					
			for(my $j=1; $j<=$#tmp;$j++){
	
				my $spot = $header{$j};
				$spot=~s/\./-/;
				my $clus=$cluster{$spot};
				my $tt="$sample.$clus";
				if (exists $hash{$tt}){
					my $subtype=$hash{$tt};
					my @tmp0=split(/_/,$subtype);
					my $subtype2=$tmp0[0];

					print "$sample\t$subtype2\t$clus\t$spot\t$pathway\t$tmp[$j]\n";
				}
			}
		}
		$i++;

	}
	close IN;

}




