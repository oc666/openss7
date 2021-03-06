#!/usr/bin/perl

eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
	if $running_under_some_shell;

my $program = $0; $program =~ s/^.*\///;
my $progdir = $0; $progdir =~ s/\/[^\/]*$//;
my $datadir = $progdir;
my $geondir = "$progdir/../geonames";
my $nanpdir = "$progdir/../nanpa";
my $codedir = "$progdir/..";

use strict;
use Data::Dumper;
use Encode qw(encode decode);
use Text::Levenshtein qw(distance);
use Geo::Coordinates::VandH;
use POSIX;
use File::stat;
use Time::gmtime;
use Date::Parse;
use DBI;

require "$progdir/../makedb.pm";

binmode(STDERR,':utf8');

my %nsnxxrg = (
	'202'=>'NS',
	'203'=>'NS',
	'204'=>'NS',
	'205'=>'NS',
	'206'=>'PE',
	'207'=>'NS',
	'208'=>'PE',
	'209'=>'NS',
	'210'=>'NS',
	'211'=>'NS',
	'212'=>'NS',
	'213'=>'PE',
	'214'=>'PE',
	'215'=>'PE',
	'216'=>'NS',
	'217'=>'NS',
	'218'=>'PE',
	'219'=>'NS',
	'220'=>'NS',
	'221'=>'NS',
	'222'=>'NS',
	'223'=>'NS',
	'224'=>'NS',
	'225'=>'NS',
	'226'=>'NS',
	'227'=>'NS',
	'228'=>'NS',
	'229'=>'NS',
	'230'=>'NS',
	'231'=>'PE',
	'232'=>'NS',
	'233'=>'NS',
	'234'=>'NS',
	'235'=>'NS',
	'236'=>'NS',
	'237'=>'NS',
	'238'=>'NS',
	'239'=>'NS',
	'240'=>'NS',
	'241'=>'NS',
	'242'=>'NS',
	'243'=>'NS',
	'244'=>'NS',
	'245'=>'NS',
	'246'=>'NS',
	'247'=>'NS',
	'248'=>'NS',
	'249'=>'NS',
	'250'=>'NS',
	'251'=>'NS',
	'252'=>'NS',
	'253'=>'NS',
	'254'=>'NS',
	'255'=>'NS',
	'256'=>'NS',
	'257'=>'NS',
	'258'=>'NS',
	'259'=>'NS',
	'260'=>'NS',
	'261'=>'NS',
	'262'=>'NS',
	'264'=>'NS',
	'265'=>'NS',
	'266'=>'NS',
	'268'=>'NS',
	'269'=>'NS',
	'270'=>'NS',
	'271'=>'NS',
	'272'=>'NS',
	'273'=>'NS',
	'274'=>'NS',
	'275'=>'NS',
	'276'=>'NS',
	'277'=>'NS',
	'278'=>'NS',
	'279'=>'NS',
	'280'=>'NS',
	'281'=>'NS',
	'282'=>'NS',
	'283'=>'PE',
	'284'=>'NS',
	'285'=>'NS',
	'286'=>'NS',
	'287'=>'NS',
	'288'=>'PE',
	'289'=>'NS',
	'290'=>'PE',
	'291'=>'PE',
	'292'=>'NS',
	'293'=>'NS',
	'294'=>'NS',
	'295'=>'NS',
	'296'=>'NS',
	'297'=>'NS',
	'298'=>'NS',
	'299'=>'NS',
	'300'=>'NS',
	'301'=>'NS',
	'302'=>'NS',
	'303'=>'PE',
	'304'=>'NS',
	'305'=>'NS',
	'306'=>'NS',
	'307'=>'NS',
	'308'=>'NS',
	'309'=>'NS',
	'310'=>'NS',
	'311'=>'NS',
	'312'=>'NS',
	'313'=>'PE',
	'314'=>'PE',
	'315'=>'PE',
	'316'=>'PE',
	'317'=>'NS',
	'318'=>'NS',
	'319'=>'NS',
	'320'=>'NS',
	'321'=>'NS',
	'322'=>'NS',
	'323'=>'NS',
	'324'=>'NS',
	'325'=>'NS',
	'326'=>'PE',
	'327'=>'PE',
	'328'=>'NS',
	'329'=>'NS',
	'330'=>'PE',
	'331'=>'NS',
	'332'=>'NS',
	'333'=>'NS',
	'334'=>'NS',
	'335'=>'NS',
	'336'=>'NS',
	'337'=>'NS',
	'338'=>'NS',
	'340'=>'NS',
	'341'=>'NS',
	'342'=>'NS',
	'343'=>'NS',
	'344'=>'NS',
	'345'=>'NS',
	'346'=>'NS',
	'347'=>'NS',
	'348'=>'NS',
	'349'=>'NS',
	'350'=>'NS',
	'351'=>'NS',
	'352'=>'NS',
	'354'=>'NS',
	'355'=>'PE',
	'356'=>'NS',
	'357'=>'PE',
	'358'=>'NS',
	'361'=>'PE',
	'362'=>'NS',
	'363'=>'NS',
	'364'=>'NS',
	'365'=>'NS',
	'366'=>'NS',
	'367'=>'PE',
	'368'=>'PE',
	'369'=>'NS',
	'370'=>'PE',
	'371'=>'NS',
	'372'=>'PE',
	'373'=>'NS',
	'374'=>'PE',
	'375'=>'NS',
	'376'=>'NS',
	'377'=>'NS',
	'378'=>'NS',
	'379'=>'NS',
	'380'=>'PE',
	'381'=>'PE',
	'382'=>'NS',
	'383'=>'NS',
	'384'=>'NS',
	'385'=>'NS',
	'386'=>'NS',
	'387'=>'NS',
	'388'=>'PE',
	'389'=>'NS',
	'390'=>'NS',
	'392'=>'NS',
	'393'=>'PE',
	'394'=>'PE',
	'396'=>'NS',
	'401'=>'NS',
	'402'=>'NS',
	'403'=>'NS',
	'404'=>'NS',
	'405'=>'NS',
	'406'=>'NS',
	'407'=>'NS',
	'411'=>'NS',
	'412'=>'NS',
	'414'=>'NS',
	'420'=>'NS',
	'421'=>'NS',
	'422'=>'NS',
	'423'=>'NS',
	'424'=>'NS',
	'425'=>'NS',
	'426'=>'NS',
	'427'=>'NS',
	'428'=>'NS',
	'429'=>'NS',
	'430'=>'NS',
	'431'=>'NS',
	'432'=>'PE',
	'433'=>'NS',
	'434'=>'NS',
	'435'=>'NS',
	'436'=>'PE',
	'437'=>'PE',
	'438'=>'PE',
	'439'=>'PE',
	'440'=>'NS',
	'441'=>'NS',
	'442'=>'NS',
	'443'=>'NS',
	'444'=>'NS',
	'445'=>'NS',
	'446'=>'NS',
	'447'=>'NS',
	'448'=>'NS',
	'449'=>'NS',
	'450'=>'NS',
	'451'=>'NS',
	'452'=>'NS',
	'453'=>'NS',
	'454'=>'NS',
	'455'=>'NS',
	'456'=>'NS',
	'457'=>'NS',
	'458'=>'NS',
	'459'=>'NS',
	'460'=>'NS',
	'461'=>'NS',
	'462'=>'NS',
	'463'=>'NS',
	'464'=>'NS',
	'465'=>'NS',
	'466'=>'NS',
	'467'=>'NS',
	'468'=>'NS',
	'469'=>'NS',
	'470'=>'NS',
	'471'=>'NS',
	'472'=>'NS',
	'473'=>'NS',
	'474'=>'NS',
	'475'=>'NS',
	'476'=>'NS',
	'477'=>'NS',
	'478'=>'NS',
	'479'=>'NS',
	'480'=>'NS',
	'481'=>'NS',
	'482'=>'NS',
	'483'=>'NS',
	'484'=>'NS',
	'485'=>'NS',
	'486'=>'NS',
	'487'=>'NS',
	'488'=>'NS',
	'489'=>'NS',
	'490'=>'NS',
	'491'=>'NS',
	'492'=>'NS',
	'493'=>'NS',
	'494'=>'NS',
	'495'=>'NS',
	'496'=>'NS',
	'497'=>'NS',
	'498'=>'NS',
	'499'=>'NS',
	'511'=>'NS',
	'512'=>'NS',
	'514'=>'NS',
	'515'=>'NS',
	'521'=>'NS',
	'522'=>'NS',
	'523'=>'NS',
	'524'=>'NS',
	'525'=>'NS',
	'526'=>'NS',
	'527'=>'NS',
	'528'=>'NS',
	'529'=>'NS',
	'530'=>'NS',
	'531'=>'NS',
	'532'=>'NS',
	'533'=>'NS',
	'534'=>'NS',
	'535'=>'NS',
	'536'=>'NS',
	'537'=>'NS',
	'538'=>'NS',
	'539'=>'NS',
	'541'=>'NS',
	'542'=>'NS',
	'543'=>'NS',
	'544'=>'NS',
	'545'=>'NS',
	'546'=>'NS',
	'547'=>'NS',
	'548'=>'NS',
	'549'=>'NS',
	'551'=>'NS',
	'552'=>'NS',
	'553'=>'NS',
	'555'=>'NS',
	'556'=>'PE',
	'557'=>'PE',
	'558'=>'NS',
	'559'=>'NS',
	'560'=>'NS',
	'561'=>'NS',
	'562'=>'NS',
	'563'=>'NS',
	'564'=>'NS',
	'565'=>'NS',
	'566'=>'PE',
	'567'=>'NS',
	'568'=>'NS',
	'569'=>'PE',
	'572'=>'NS',
	'574'=>'NS',
	'575'=>'NS',
	'576'=>'NS',
	'577'=>'NS',
	'578'=>'NS',
	'579'=>'NS',
	'580'=>'NS',
	'581'=>'NS',
	'582'=>'NS',
	'583'=>'PE',
	'584'=>'NS',
	'585'=>'NS',
	'586'=>'NS',
	'587'=>'NS',
	'588'=>'NS',
	'592'=>'NS',
	'594'=>'NS',
	'595'=>'NS',
	'597'=>'NS',
	'598'=>'PE',
	'611'=>'NS',
	'614'=>'NS',
	'616'=>'NS',
	'618'=>'NS',
	'619'=>'NS',
	'620'=>'PE',
	'621'=>'PE',
	'622'=>'NS',
	'623'=>'NS',
	'624'=>'NS',
	'625'=>'NS',
	'626'=>'PE',
	'627'=>'NS',
	'628'=>'PE',
	'629'=>'PE',
	'630'=>'NS',
	'631'=>'NS',
	'632'=>'NS',
	'633'=>'NS',
	'634'=>'NS',
	'635'=>'NS',
	'636'=>'NS',
	'637'=>'NS',
	'638'=>'NS',
	'639'=>'NS',
	'640'=>'NS',
	'641'=>'NS',
	'642'=>'NS',
	'643'=>'NS',
	'644'=>'NS',
	'645'=>'NS',
	'646'=>'NS',
	'647'=>'NS',
	'648'=>'NS',
	'649'=>'NS',
	'650'=>'NS',
	'651'=>'PE',
	'652'=>'PE',
	'653'=>'NS',
	'654'=>'NS',
	'655'=>'NS',
	'656'=>'NS',
	'657'=>'NS',
	'658'=>'PE',
	'659'=>'PE',
	'660'=>'NS',
	'661'=>'NS',
	'662'=>'NS',
	'663'=>'NS',
	'664'=>'NS',
	'665'=>'NS',
	'667'=>'NS',
	'668'=>'NS',
	'669'=>'NS',
	'670'=>'NS',
	'671'=>'NS',
	'672'=>'PE',
	'673'=>'NS',
	'674'=>'NS',
	'675'=>'PE',
	'676'=>'PE',
	'677'=>'NS',
	'678'=>'NS',
	'679'=>'NS',
	'680'=>'NS',
	'681'=>'NS',
	'682'=>'NS',
	'683'=>'NS',
	'684'=>'NS',
	'685'=>'NS',
	'686'=>'NS',
	'687'=>'PE',
	'688'=>'NS',
	'689'=>'NS',
	'690'=>'NS',
	'691'=>'NS',
	'692'=>'NS',
	'693'=>'NS',
	'694'=>'NS',
	'695'=>'NS',
	'697'=>'NS',
	'698'=>'NS',
	'699'=>'NS',
	'700'=>'NS',
	'701'=>'NS',
	'711'=>'NS',
	'714'=>'NS',
	'718'=>'NS',
	'719'=>'NS',
	'720'=>'NS',
	'721'=>'NS',
	'722'=>'NS',
	'723'=>'NS',
	'724'=>'PE',
	'725'=>'NS',
	'726'=>'PE',
	'727'=>'NS',
	'728'=>'NS',
	'729'=>'PE',
	'730'=>'PE',
	'731'=>'PE',
	'732'=>'NS',
	'733'=>'NS',
	'734'=>'PE',
	'735'=>'NS',
	'736'=>'NS',
	'737'=>'NS',
	'738'=>'NS',
	'739'=>'PE',
	'740'=>'NS',
	'741'=>'PE',
	'742'=>'NS',
	'743'=>'PE',
	'744'=>'NS',
	'745'=>'NS',
	'746'=>'NS',
	'747'=>'NS',
	'748'=>'NS',
	'749'=>'NS',
	'750'=>'NS',
	'751'=>'NS',
	'752'=>'NS',
	'753'=>'NS',
	'754'=>'NS',
	'755'=>'NS',
	'756'=>'NS',
	'757'=>'NS',
	'758'=>'NS',
	'759'=>'NS',
	'760'=>'NS',
	'761'=>'NS',
	'762'=>'NS',
	'763'=>'NS',
	'764'=>'NS',
	'765'=>'NS',
	'766'=>'NS',
	'767'=>'NS',
	'768'=>'NS',
	'769'=>'NS',
	'770'=>'NS',
	'771'=>'NS',
	'772'=>'NS',
	'773'=>'NS',
	'775'=>'PE',
	'776'=>'NS',
	'777'=>'NS',
	'778'=>'NS',
	'779'=>'NS',
	'783'=>'NS',
	'784'=>'PE',
	'786'=>'PE',
	'787'=>'NS',
	'788'=>'NS',
	'789'=>'NS',
	'790'=>'NS',
	'791'=>'NS',
	'792'=>'NS',
	'794'=>'NS',
	'795'=>'PE',
	'796'=>'NS',
	'798'=>'NS',
	'799'=>'NS',
	'800'=>'NS',
	'801'=>'NS',
	'802'=>'NS',
	'803'=>'NS',
	'804'=>'NS',
	'805'=>'NS',
	'806'=>'PE',
	'807'=>'PE',
	'808'=>'PE',
	'811'=>'NS',
	'812'=>'PE',
	'813'=>'PE',
	'814'=>'NS',
	'815'=>'NS',
	'816'=>'PE',
	'817'=>'NS',
	'818'=>'NS',
	'819'=>'NS',
	'820'=>'NS',
	'821'=>'NS',
	'822'=>'NS',
	'823'=>'NS',
	'824'=>'NS',
	'825'=>'NS',
	'826'=>'NS',
	'827'=>'NS',
	'828'=>'NS',
	'829'=>'NS',
	'830'=>'NS',
	'831'=>'PE',
	'832'=>'NS',
	'833'=>'NS',
	'834'=>'NS',
	'835'=>'NS',
	'836'=>'PE',
	'837'=>'NS',
	'838'=>'PE',
	'839'=>'NS',
	'840'=>'NS',
	'841'=>'NS',
	'842'=>'NS',
	'843'=>'NS',
	'844'=>'NS',
	'845'=>'NS',
	'846'=>'PE',
	'847'=>'NS',
	'848'=>'NS',
	'849'=>'NS',
	'850'=>'NS',
	'852'=>'NS',
	'853'=>'PE',
	'854'=>'PE',
	'855'=>'PE',
	'856'=>'PE',
	'857'=>'NS',
	'858'=>'NS',
	'859'=>'PE',
	'860'=>'NS',
	'861'=>'NS',
	'862'=>'NS',
	'863'=>'NS',
	'864'=>'NS',
	'865'=>'NS',
	'866'=>'NS',
	'867'=>'NS',
	'868'=>'NS',
	'869'=>'NS',
	'870'=>'NS',
	'871'=>'NS',
	'872'=>'NS',
	'873'=>'NS',
	'874'=>'NS',
	'875'=>'NS',
	'876'=>'NS',
	'877'=>'NS',
	'878'=>'NS',
	'879'=>'NS',
	'880'=>'NS',
	'881'=>'NS',
	'882'=>'PE',
	'883'=>'NS',
	'884'=>'NS',
	'885'=>'NS',
	'886'=>'PE',
	'887'=>'PE',
	'888'=>'PE',
	'889'=>'NS',
	'890'=>'NS',
	'891'=>'NS',
	'892'=>'PE',
	'893'=>'NS',
	'894'=>'PE',
	'895'=>'NS',
	'896'=>'NS',
	'897'=>'NS',
	'898'=>'NS',
	'899'=>'NS',
	'911'=>'NS',
	'921'=>'NS',
	'922'=>'NS',
	'923'=>'NS',
	'924'=>'NS',
	'925'=>'NS',
	'926'=>'NS',
	'928'=>'NS',
	'929'=>'NS',
	'931'=>'NS',
	'935'=>'NS',
	'940'=>'PE',
	'945'=>'NS',
	'947'=>'NS',
	'951'=>'NS',
	'952'=>'NS',
	'953'=>'NS',
	'954'=>'PE',
	'956'=>'NS',
	'957'=>'NS',
	'958'=>'NB',
	'960'=>'PE',
	'961'=>'PE',
	'962'=>'PE',
	'963'=>'PE',
	'964'=>'PE',
	'965'=>'NS',
	'968'=>'NS',
	'969'=>'PE',
	'971'=>'NS',
	'977'=>'NS',
	'978'=>'PE',
	'979'=>'NS',
	'980'=>'NS',
	'981'=>'NS',
	'982'=>'NS',
	'986'=>'NS',
	'989'=>'NS',
	'997'=>'NS',
	'998'=>'NS',
	'999'=>'NS',
);

my %ntnxxrg = (
	'206'=>'NT',
	'211'=>'YT',
	'222'=>'VU',
	'252'=>'VU',
	'266'=>'VU',
	'311'=>'YT',
	'322'=>'YT',
	'332'=>'YT',
	'333'=>'YT',
	'334'=>'YT',
	'335'=>'YT',
	'336'=>'YT',
	'360'=>'VU',
	'370'=>'NT',
	'371'=>'NT',
	'390'=>'YT',
	'392'=>'NT',
	'393'=>'YT',
	'394'=>'NT',
	'396'=>'NT',
	'399'=>'YT',
	'411'=>'YT',
	'436'=>'VU',
	'439'=>'VU',
	'444'=>'NT',
	'445'=>'NT',
	'446'=>'NT',
	'455'=>'YT',
	'456'=>'YT',
	'462'=>'VU',
	'473'=>'VU',
	'511'=>'YT',
	'536'=>'YT',
	'537'=>'YT',
	'555'=>'YT',
	'561'=>'VU',
	'573'=>'NT',
	'580'=>'NT',
	'581'=>'NT',
	'587'=>'NT',
	'588'=>'NT',
	'589'=>'NT',
	'598'=>'NT',
	'602'=>'NT',
	'611'=>'YT',
	'620'=>'NT',
	'621'=>'NT',
	'633'=>'YT',
	'634'=>'YT',
	'645'=>'VU',
	'660'=>'YT',
	'667'=>'YT',
	'668'=>'YT',
	'669'=>'NT',
	'678'=>'NT',
	'690'=>'NT',
	'695'=>'NT',
	'699'=>'NT',
	'709'=>'NT',
	'711'=>'YT',
	'713'=>'NT',
	'765'=>'NT',
	'766'=>'NT',
	'767'=>'NT',
	'769'=>'VU',
	'770'=>'NT',
	'777'=>'NT',
	'793'=>'VU',
	'809'=>'NT',
	'811'=>'YT',
	'821'=>'YT',
	'825'=>'NT',
	'841'=>'YT',
	'851'=>'YT',
	'857'=>'VU',
	'862'=>'YT',
	'863'=>'YT',
	'870'=>'NT',
	'872'=>'NT',
	'873'=>'NT',
	'874'=>'NT',
	'875'=>'NT',
	'876'=>'NT',
	'880'=>'NT',
	'896'=>'VU',
	'897'=>'VU',
	'898'=>'VU',
	'899'=>'VU',
	'911'=>'YT',
	'920'=>'NT',
	'924'=>'VU',
	'925'=>'VU',
	'927'=>'VU',
	'928'=>'VU',
	'934'=>'VU',
	'939'=>'VU',
	'952'=>'NT',
	'953'=>'NT',
	'958'=>'NT',
	'959'=>'NT',
	'966'=>'YT',
	'969'=>'YT',
	'974'=>'VU',
	'975'=>'VU',
	'977'=>'NT',
	'978'=>'NT',
	'979'=>'VU',
	'980'=>'VU',
	'982'=>'VU',
	'983'=>'VU',
	'984'=>'NT',
	'993'=>'YT',
	'994'=>'YT',
	'995'=>'YT',
	'996'=>'YT',
	'997'=>'NT',
	'999'=>'NT',
);

my %ccst2rg = ();
my %ccst2pc = ();
my %ccst2ps = ();
my %pcps2rg = ();

sub dolergst {
	my $fn = "$codedir/lergst.txt";
	print STDERR "I: reading $fn\n";
	open(INFILE,"<:utf8",$fn) or die "can't read $fn";
	while (<INFILE>) { chomp;
		next unless /^[A-Z][A-Z]\t/;
		my @tokens = split(/\t/,$_);
		$ccst2rg{$tokens[0]}{$tokens[1]} = $tokens[2];
		$ccst2pc{$tokens[0]}{$tokens[1]} = $tokens[4] if $tokens[4] ne 'ZZ';
		$ccst2ps{$tokens[0]}{$tokens[1]} = $tokens[5] if $tokens[5] ne 'XX';
		$pcps2rg{$tokens[4]}{$tokens[5]} = $tokens[2] if $tokens[2] ne 'XX' and $tokens[2] ne 'ZZ';
	}
	close(INFILE);
}

my %npapc = ();
my %npaps = ();
my %nparg = ();

sub donanpst {
	my $fn = "$nanpdir/nanpst.txt";
	print STDERR "I: reading $fn\n";
	open(INFILE,"<:utf8",$fn) or die "can't read $fn";
	while (<INFILE>) { chomp;
		my @tokens = split(/\t/,$_);
		unless ($tokens[0] =~ /[2-9]11/) {
			if ($tokens[2]) {
				$nparg{$tokens[0]} = $ccst2rg{$tokens[1]}{$tokens[2]};
				$npapc{$tokens[0]} = $ccst2pc{$tokens[1]}{$tokens[2]};
				$npaps{$tokens[0]} = $ccst2ps{$tokens[1]}{$tokens[2]};
			} elsif ($tokens[1]) {
				$npapc{$tokens[0]} = $tokens[1];
			}
		}
	}
	close(INFILE);
}

sub doallnpas {
	my $dbh = shift;
	$dbh->begin_work;
	my %mapping = (
		'NPA'=>\&makedb::simplefield,
		'Type of Code'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::mappedfield($dat,'type',$val,{
					'General Purpose Code'=>'G',
					'Easily Recognizable Code'=>'E',
				});
		},
		'Assignable'=>\&makedb::booleanfield,
		'Explanation'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::mappedfield($dat,$fld,$val,{
					'Carrier Access'=>'CA',
					'Directory Assistance'=>'DA',
					'Expansion Code'=>'EXP',
					'N11 Code'=>'N11',
					'Reserved by INC'=>'INC',
					'Set aside for toll free'=>'TF',
				});
		},
		'Reserved'=>\&makedb::booleanfield,
		'Assigned?'=>\&makedb::booleanfield,
		'Asgt Date'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::datefield($dat,'assigndate',$val);
		},
		'Use'=>\&makedb::simplefield,
		'Service'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::mappedfield($dat,$fld,$val,{
					'Canadian Services'=>'CDN',
					'Inbound International'=>'INT',
					'Interexchange Carrier Services'=>'IXC',
					'Personal Communication Service'=>'PCS',
					'Premium Services'=>'9XX',
					'US Government'=>'GOV',
					'Toll-Free'=>'8XX',
				});
		},
		'Location'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::mappedfield($dat,$fld,$val,{
					'AK'=>'AK',
					'AL'=>'AL',
					'Alberta'=>'AB',
					'Anguilla'=>'AI',
					'Antigua/Barbuda'=>'AN',
					'AR'=>'AR',
					'AS'=>'AS',
					'AZ'=>'AZ',
					'Bahamas'=>'BA',
					'Barbados'=>'BD',
					'Bermuda'=>'BM',
					'British Columbia'=>'BC',
					'British Virgin Islands'=>'BV',
					'CA'=>'CA',
					'Canada'=>'',
					'Cayman Islands'=>'CQ',
					'CNMI'=>'MP',
					'CO'=>'CO',
					'CT'=>'CT',
					'DC'=>'DC',
					'DE'=>'DE',
					'Dominica'=>'DM',
					'Dominican Republic'=>'DR',
					'FL'=>'FL',
					'GA'=>'GA',
					'Grenada'=>'GN',
					'GU'=>'GU',
					'HI'=>'HI',
					'IA'=>'IA',
					'ID'=>'ID',
					'IL'=>'IL',
					'IN'=>'IN',
					'Jamaica'=>'JM',
					'KS'=>'KS',
					'KY'=>'KY',
					'LA'=>'LA',
					'MA'=>'MA',
					'Manitoba'=>'MB',
					'MD'=>'MD',
					'ME'=>'ME',
					'MI'=>'MI',
					'MN'=>'MN',
					'MO'=>'MO',
					'Montserrat'=>'RT',
					'MS'=>'MS',
					'MT'=>'MT',
					'NANP area'=>'',
					'NANP Area'=>'',
					'NC'=>'NC',
					'ND'=>'ND',
					'NE'=>'NE',
					'New Brunswick'=>'NB',
					'Newfoundland'=>'NL',
					'NH'=>'NH',
					'NJ'=>'NJ',
					'NM'=>'NM',
					'Nova Scotia, Prince Edward Island'=>'NS', # requires further decoding
					'NV'=>'NV',
					'NY'=>'NY',
					'OH'=>'OH',
					'OK'=>'OK',
					'Ontario'=>'ON',
					'OR'=>'OR',
					'PA'=>'PA',
					'Puerto Rico'=>'PR',
					'Quebec'=>'QC',
					'RI'=>'RI',
					'Saskatchewan'=>'SK',
					'SC'=>'SC',
					'SD'=>'SD',
					'Sint Maarten'=>'SF',
					'St. Kitts & Nevis'=>'KA',
					'St. Lucia'=>'SA',
					'St. Vincent & Grenadines'=>'ZF',
					'TN'=>'TN',
					'Trinidad & Tobago'=>'TR',
					'Turks & Caicos Islands'=>'TC',
					'TX'=>'TX',
					'US'=>'',
					'USVI'=>'VI',
					'UT'=>'UT',
					'VA'=>'VA',
					'VT'=>'VT',
					'WA'=>'WA',
					'WI'=>'WI',
					'WV'=>'WV',
					'WY'=>'WY',
					'Yukon, NW Terr., Nunavut'=>'NT', # requires further decoding
				});
			if ($dat->{location} ne $npaps{$dat->{npa}}) {
				print STDERR "E: conflicting location assignments NPA $dat->{npa}: '$dat->{location}' <-> '$npaps{$dat->{npa}}'\n";
			}
		},
		'Country'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::mappedfield($dat,$fld,$val,{
					'ANGUILLA'=>'AI',
					'ANTIGUA/BARBUDA'=>'AG',
					'BAHAMAS'=>'BS',
					'BARBADOS'=>'BB',
					'BERMUDA'=>'BM',
					'BRITISH VIRGIN ISLANDS'=>'VG',
					'CANADA'=>'CA',
					'CAYMAN ISLANDS'=>'KY',
					'DOMINICA'=>'DM',
					'Dominican Republic'=>'DO',
					'GRENADA'=>'GD',
					'JAMAICA'=>'JM',
					'MONTSERRAT'=>'MS',
					'SINT MAARTEN'=>'SX',
					'ST. KITTS AND NEVIS'=>'KN',
					'ST. LUCIA'=>'LC',
					'ST. VINCENT & GRENADINES'=>'VC',
					'TRINIDAD AND TOBAGO'=>'TT',
					'TURKS & CAICOS ISLANDS'=>'TC',
					'US'=>'US',
				});
			if ($dat->{country} ne $npapc{$dat->{npa}}) {
				print STDERR "E: conflicting country assignments NPA $dat->{npa}: '$dat->{country}' <-> '$npapc{$dat->{npa}}'\n";
			}
		},
		'In Service?'=>\&makedb::booleanfield,
		'In Svc Date'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::datefield($dat,'effdate',$val);
		},
		'Status'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::mappedfield($dat,$fld,$val,{
					'Active'=>'A',
					'Suspended'=>'S',
				});
		},
		'PL'=>\&makedb::simplefield,
		'Overlay'=>\&makedb::booleanfield,
		'Overlay Complex'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'complex',$val);
		},
		'Parent'=>\&makedb::simplefield,
		'Time Zone'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'tzones',$val);
		},
		'Map'=>\&makedb::simplefield,
		'Is NPA in Jeoparady?'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::booleanfield($dat,'jeoparady',$val);
		},
		'Is Relief Planning in Progress'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::booleanfield($dat,'relief',$val);
		},
		'Home NPA Local Calls'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'hnpalocl',$val);
		},
		'Home NPA Toll Calls'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'hnpatoll',$val);
		},
		'Foreign NPA Local Calls'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'fnpalocl',$val);
		},
		'Foreign NPA Toll Calls'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'fnpatoll',$val);
		},
		'perm HNPA local'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'permhnpalocl',$val);
		},
		'perm HNPA toll'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'permhnpatoll',$val);
		},
		'perm FNPA local'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'permfnpalocl',$val);
		},
		'dp Notes'=>\&makedb::simplefield,
	);
	my $fn = "$progdir/AllNPAs.mdb";
	print STDERR "processing $fn\n";
	my $fdate = stat($fn)->mtime;
	open(INFILE,"mdb-export -Q \"-d\\t\" '-D%F' $fn 'Public NPA Database Table' |") or die "can't process $fn";
	my $header = 1;
	my @fields = ();
	while (<INFILE>) { chomp;
		my @tokens = split(/\t/,$_);
		if ($header) {
			@fields = @tokens;
			$header = undef;
			next;
		}
		my %data = (fdate=>$fdate);
		for (my $i=0;$i<@fields;$i++) {
			if (exists $mapping{$fields[$i]}) {
				&{$mapping{$fields[$i]}}(\%data,$fields[$i],$tokens[$i]);
			} else {
				print STDERR "W: no mapping for $fn:$fields[$i]\n";
			}
		}
		my $sect = "NANPA-$data{npa}";
		makedb::updatedata(\%data,$fdate,$sect) if $data{npa};
		#updateit(\%data,'npadata',[$data{npa}]) if $data{npa};
	}
	close(INFILE);
	$dbh->commit;
}

sub donpanxx {
	my $dbh = shift;
	$dbh->begin_work;
	my $fn = "$progdir/NPANXX.zip";
	print STDERR "I: processing $fn\n";
	open(INFILE,"unzip -p $fn cygdrive/d/cna/COCode-ESRDData/NPANXX.csv |") or die "can't process $fn";
	my $header = 1;
	my @fields = ();
	my $fdate = stat($fn)->mtime;
	my %mapping = (
		'NPA'=>sub{
			my ($dat,$fld,$val) = @_;
			if (length($val)) {
				makedb::simplefield(@_);
				if (exists $nparg{$val}) {
					$dat->{region} = $nparg{$val};
				} else {
					print STDERR "E: no region for NPA $val\n";
				}
			}
		},
		'NXX'=>sub{
			my ($dat,$fld,$val) = @_;
			if (length($val)) {
				makedb::simplefield(@_);
				$dat->{region} = $ntnxxrg{$val} if $dat->{region} eq 'NT' and exists $ntnxxrg{$val};
				$dat->{region} = $nsnxxrg{$val} if $dat->{region} eq 'NS' and exists $nsnxxrg{$val};
			}
		},
		'OCN'=>\&makedb::simplefield,
		'Company'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'companyname',$val);
		},
		'Status'=>sub{
			my ($dat,$fld,$val) = @_;
			if (length($val)) {
				makedb::simplefield(@_);
				makedb::mappedfield($dat,$fld,$val,{
						'Assigned'=>'AS',
						'Available'=>'AV',
						'Available as Initial Code only'=>'IC',
						'Being Recovered'=>'BR',
						'For Special Use'=>'SU',
						'In Service'=>'IS',
						'Moratorium on Assignment'=>'MA',
						'New Entrants Reserved'=>'NE',
						'New NPA Testing'=>'NT',
						'Not Available'=>'UA',
						'Plant Test'=>'PT',
						'Protected'=>'PR',
						'Recovered/Aging'=>'RA',
						'Relief NPA'=>'RN',
						'Temporarily Unavailable'=>'TU',
					});
				makedb::mappedfield($dat,'nxxuse',$val,{
						'Assigned'=>'AS',
						'Available'=>'UA',
						'Available as Initial Code only'=>'UA',
						'Being Recovered'=>'AS',
						'For Special Use'=>'AS',
						'In Service'=>'AS',
						'Moratorium on Assignment'=>'UA',
						'New Entrants Reserved'=>'UA',
						'New NPA Testing'=>'AS',
						'Not Available'=>'UA',
						'Plant Test'=>'AS',
						'Protected'=>'AS',
						'Recovered/Aging'=>'UA',
						'Relief NPA'=>'UA',
						'Temporarily Unavailable'=>'UA',
					});
			}
		},
		'RateCenter'=>sub{
			my ($dat,$fld,$val) = @_;
			makedb::simplefield($dat,'rc',$val);
		},
		'Remarks'=>\&makedb::simplefield,
	);
	while (<INFILE>) { chomp; s/\r//g;
		s/^"//; s/"$//; my @tokens = split(/","/,$_);
		if ($header) {
			@fields = @tokens;
			$header = undef;
			next;
		}
		my %data = (fdate=>$fdate);
		for (my $i=0;$i<@fields;$i++) {
			if (exists $mapping{$fields[$i]}) {
				&{$mapping{$fields[$i]}}(\%data,$fields[$i],$tokens[$i]);
			} else {
				print STDERR "E: no mapping for $fn:$fields[$i]\n";
			}
		}
		my $sect = "CNA-$data{npa}-$data{nxx}";
		makedb::updatedata(\%data,$fdate,$sect) if $data{npa} and $data{nxx};
		#updateit(\%data,'nxxdata',[$data{npa},$data{nxx}]) if $data{npa} and $data{nxx};
		#updateit(\%data,'ocndata',[$data{ocn}]) if $data{ocn};
	}
	close(INFILE);
	$dbh->commit;
}

sub dodiscon {
	my $dbh = shift;
	$dbh->begin_work;
	my %mapping = (
		'State'=>sub{
			my ($dat,$fld,$val) = @_;
			$dat->{region} = $val if length($val);
		},
		'NPA'=>sub{
			my ($dat,$fld,$val) = @_;
			$dat->{"\L$fld\E"} = $val if length($val);
		},
		'NXX'=>sub{
			my ($dat,$fld,$val) = @_;
			$dat->{"\L$fld\E"} = $val if length($val);
		},
		'EffectiveDate'=>sub{
			my ($dat,$fld,$val) = @_;
			if (length($val)) {
				$val = $val * 24 * 60 * 60;
				$val = $val + (str2time("1900-01-01") - str2time("1970-01-01"));
				$dat->{effdate} = $val;
			}
		},
	);
	my $fn = "discon.xls";
	print STDERR "I: processing $fn\n";
	open(INFILE,"py_xls2csv $fn | sed -e '".'s/, ,/,"",/g;s/, ,/,"",/g;s/^,/"",/;s/,$$/,""/;s/", "/","/g;s/\.0"/"/g'."' |") or die "can't process $fn";
	my $fdate = stat($fn)->mtime;
	my $heading = 1;
	my @fields = ();
	while (<INFILE>) { chomp; s/\r//g; chomp;
		next if /^Sheet/;
		next if /^-----/;
		s/^"//; s/"$//; my @tokens = split(/","/,$_);
		if ($heading) {
			@fields = @tokens;
			$heading = undef;
			next;
		}
		if (/^$/) {
			@fields = ();
			$heading = 1;
			next;
		}
		my %data = (fdate=>$fdate);
		for (my $i=0;$i<@fields;$i++) {
			if (exists $mapping{$fields[$i]}) {
				&{$mapping{$fields[$i]}}(\%data,$fields[$i],$tokens[$i]);
			} else {
				print STDERR "E: no field mapping for $fields[$i]\n";
			}
		}
		$data{discon} = 1;
		my $sect = "NANPA-$data{npa}-$data{nxx}";
		makedb::updatedata(\%data,$fdate,$sect) if $data{npa} and $data{nxx};
		#updateit(\%data,'nxxdata',[$data{npa},$data{nxx}]) if $data{npa} and $data{nxx};
	}
	close(INFILE);
	$dbh->commit;
}

sub dospecial {
	my $dbh = shift;
	$dbh->begin_work;
	my %mapping = (
		'STATE'=>sub{
			my ($dat,$fld,$val) = @_;
			$dat->{region} = $val if length($val);
		},
		'NPA'=>sub{
			my ($dat,$fld,$val) = @_;
			$dat->{"\L$fld\E"} = $val if length($val);
		},
		'NXX'=>sub{
			my ($dat,$fld,$val) = @_;
			$dat->{"\L$fld\E"} = $val if length($val);
		},
		'RATE CENTER ABBREVIATION'=>sub{
			my ($dat,$fld,$val) = @_;
			$dat->{rcshort} = $val if length($val);
		},
		'NOTES'=>sub{
			my ($dat,$fld,$val) = @_;
			$dat->{"\L$fld\E"} = $val if length($val);
		},
	);
	my $fn = "special.xls";
	print STDERR "I: processing $fn\n";
	open(INFILE,"py_xls2csv $fn | sed -e '".'s/, ,/,"",/g;s/, ,/,"",/g;s/^,/"",/;s/,$$/,""/;s/", "/","/g;s/\.0"/"/g'."' |") or die "can't process $fn";
	my $fdate = stat($fn)->mtime;
	my $heading = 1;
	my @fields = ();
	while (<INFILE>) { chomp; s/\r//g; chomp;
		next if /^Sheet/;
		next if /^-----/;
		s/^"//; s/"$//; my @tokens = split(/","/,$_);
		if ($heading) {
			@fields = @tokens;
			$heading = undef;
			next;
		}
		if (/^$/) {
			@fields = ();
			$heading = 1;
			next;
		}
		my %data = (fdate=>$fdate);
		for (my $i=0;$i<@fields;$i++) {
			if (exists $mapping{$fields[$i]}) {
				&{$mapping{$fields[$i]}}(\%data,$fields[$i],$tokens[$i]);
			} else {
				print STDERR "E: no field mapping for $fields[$i]\n";
			}
		}
		$data{special} = 1;
		my $sect = "NANPA-$data{npa}-$data{nxx}";
		makedb::updatedata(\%data,$fdate,$sect) if $data{npa} and $data{nxx};
		#updateit(\%data,'nxxdata',[$data{npa},$data{nxx}]) if $data{npa} and $data{nxx};
	}
	close(INFILE);
	$dbh->commit;
}

sub doallutlzd {
	my $dbh = shift;
	$dbh->begin_work;
	my %mapping = (
		'region'=>\&makedb::simplefield,
		'npa'=>sub{
			my ($dat,$fld,$val) = @_;
			if (length($val)) {
				makedb::simplefield(@_);
				my $region;
				if (exists $nparg{$val}) {
					$region = $nparg{$val};
				} else {
					print STDERR "E: no region for NPA $val\n";
				}
				if ($region and $region ne $dat->{region}) {
					print STDERR "W: changing state $dat->{region} -> $region\n";
				}
				$dat->{region} = $region if $region;
			}
		},
		'nxx'=>sub{
			my ($dat,$fld,$val) = @_;
			if (length($val)) {
				makedb::simplefield(@_);
				my $region = $dat->{region};
				$region = $ntnxxrg{$val} if $region eq 'NT' and exists $ntnxxrg{$val};
				$region = $nsnxxrg{$val} if $region eq 'NS' and exists $nsnxxrg{$val};
				if ($region and $region ne $dat->{region}) {
					print STDERR "W: changing state $dat->{region} -> $region\n";
				}
				$dat->{region} = $region if $region;
			}
		},
		'ocn'=>\&makedb::simplefield,
		'companyname'=>\&makedb::simplefield,
		'rcshort'=>\&makedb::simplefield,
		'effdate'=>\&makedb::datefield,
		'nxxuse'=>\&makedb::simplefield,
		'assigndate'=>\&makedb::datefield,
		'initialgrowth'=>\&makedb::simplefield, # (I|G)
	);
	my $fn = "$progdir/allutlzd.zip";
	print STDERR "I: processing $fn\n";
	open(INFILE,"unzip -p $fn allutlzd.txt | expand |") or die "can't process $fn";
	my $header = 1;
	my $fdate = stat($fn)->mtime;
	my @fields = qw/region npa nxx ocn companyname rcshort effdate nxxuse assigndate initialgrowth/;
	while (<INFILE>) { chomp;
		if ($header) {
			$header = undef;
			next;
		}
		my @tokens = ();
		$tokens[0] = substr($_,0,8); # State
		$tokens[1] = substr($_,8,8); # NPA-NXX
		$tokens[3] = substr($_,16,8); # Ocn
		$tokens[4] = substr($_,24,64); # Company
		$tokens[5] = substr($_,88,16); # RateCenter
		$tokens[6] = substr($_,104,16); # EffectiveDate
		$tokens[7] = substr($_,120,8); # Use
		$tokens[8] = substr($_,128,16); # AssignDate
		$tokens[9] = substr($_,144,16); # Intial/Growth
		for (my $i=0;$i<@tokens;$i++) {
			$tokens[$i] =~ s/^\s*"?\s*//;
			$tokens[$i] =~ s/\s*"?\s*$//;
		}
		($tokens[1],$tokens[2]) = split(/-/,$tokens[1]);
		my %data = (fdate=>$fdate);
		for (my $i=0;$i<@fields;$i++) {
			if (exists $mapping{$fields[$i]}) {
				&{$mapping{$fields[$i]}}(\%data,$fields[$i],$tokens[$i]);
			} else {
				print STDERR "E: no mapping for $fn:$fields[$i]\n";
			}
		}
		my $sect = "NANPA-$data{npa}-$data{nxx}";
		makedb::updatedata(\%data,$fdate,$sect) if $data{npa} and $data{nxx};
		#updateit(\%data,'nxxdata',[$data{npa},$data{nxx}]) if $data{npa} and $data{nxx};
		#updateit(\%data,'ocndata',[$data{ocn}]) if $data{ocn};
	}
	close(INFILE);
	$dbh->commit;
}

sub dodata {
	my $dbh = shift;
	dolergst($dbh);
	donanpst($dbh);
	doallnpas($dbh);
	dodiscon($dbh);
	dospecial($dbh);
	donpanxx($dbh);
	doallutlzd($dbh);
}

makedb::makedb('nnpadata',\&dodata);

exit;

1;

__END__
