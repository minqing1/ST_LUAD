use File::Basename;



my %hash;
open IN, "Fig3A_3B_subtype_cluster_demo.txt";
while ($line=<IN>){
	chomp $line;
	my @tmp=split(/\t/,$line);
	$hash{$tmp[1]}=$tmp[0];
	
}
close IN;


my @files=`find ./ -name "*CytoTRACE_score"`;
chomp @files;
print "Sample\tSubtype\tCluster\tScore\n";

foreach my $infile (@files){
	
	my $sample=basename $infile;
	$sample=~s/\.CytoTRACE_score//;
	
	open IN, "$infile";
	while ($line=<IN>){
		chomp $line;
		next if($line=~/Score/);
		my @tmp=split(/\t/,$line);
		my $score = $tmp[1];
		my $cluster = $tmp[2];
	
		my $tt="$sample.$cluster";
		my $subtype=$hash{$tt};
		#print "$tt\t$subtype\n";
		my @tmp0=split(/_/,$subtype);
		my $subtype2=$tmp0[0];
		

		print "$sample\t$subtype2\t$cluster\t$score\n";
		
	}
	close IN;

}


