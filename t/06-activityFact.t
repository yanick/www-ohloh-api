use strict;
use warnings;

use Test::More tests => 14;                      # last test to print

use List::MoreUtils qw/ all /;
require 't/FakeOhloh.pm';

my $ohloh = Fake::Ohloh->new;

$/ = undef;

$ohloh->stash(
    'http://www.ohloh.net/projects/123/analyses/10/activity_facts.xml',
    <DATA>,
);

my $facts = $ohloh->get_activity_facts( 10 );

my @f = $facts->all;

is scalar(@f) => 70, 'all()';
is $facts->total => 70, 'total()';
print grep { ! $_->isa( 'WWW::Ohloh::API::ActivityFact' ) } @f;
ok 0+( all { $_->isa( 'WWW::Ohloh::API::ActivityFact' ) } @f ),
   'returns W:O:A:ActivityFact';

my $f = $facts->latest;
ok $f->isa( 'WWW::Ohloh::API::ActivityFact' ), 'latest()';

like $f->month => qr/2008-01/, 'month()';
is $f->code_added => 3078, 'code_added()';
is $f->code_removed => 1555, 'code_removed()';
is $f->comments_added => 985, "comments_added()";
is $f->comments_removed => 282, "comments_removed()";
is $f->blanks_removed => 98, "blanks_removed()";
is $f->blanks_added => 486, "blanks_added()";
is $f->commits => 51, "commits()";
is $f->contributors => 3, "contributors()";

like $facts->as_xml,
    qr#<(activity_facts)>(<(activity_fact)>.*?</\3>)+</\1>#,  "as_xml()";

__DATA__
<response>
  <status>success</status>
  <items_returned>70</items_returned>
  <items_available>70</items_available>
  <first_item_position>70</first_item_position>
  <result>
    <activity_fact>
      <month>2002-04-01T00:00:00Z</month>
      <code_added>14975</code_added>
      <code_removed>376</code_removed>
      <comments_added>3682</comments_added>
      <comments_removed>182</comments_removed>
      <blanks_added>3267</blanks_added>
      <blanks_removed>41</blanks_removed>
      <commits>94</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2002-05-01T00:00:00Z</month>
      <code_added>2880</code_added>
      <code_removed>421</code_removed>
      <comments_added>840</comments_added>
      <comments_removed>136</comments_removed>
      <blanks_added>678</blanks_added>
      <blanks_removed>44</blanks_removed>
      <commits>41</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2002-06-01T00:00:00Z</month>
      <code_added>6487</code_added>
      <code_removed>2966</code_removed>
      <comments_added>1204</comments_added>
      <comments_removed>313</comments_removed>
      <blanks_added>1097</blanks_added>
      <blanks_removed>266</blanks_removed>
      <commits>114</commits>
      <contributors>6</contributors>
    </activity_fact>
    <activity_fact>
      <month>2002-07-01T00:00:00Z</month>
      <code_added>8068</code_added>
      <code_removed>4576</code_removed>
      <comments_added>2600</comments_added>
      <comments_removed>397</comments_removed>
      <blanks_added>1551</blanks_added>
      <blanks_removed>441</blanks_removed>
      <commits>142</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2002-08-01T00:00:00Z</month>
      <code_added>7044</code_added>
      <code_removed>15954</code_removed>
      <comments_added>2089</comments_added>
      <comments_removed>4808</comments_removed>
      <blanks_added>1602</blanks_added>
      <blanks_removed>3565</blanks_removed>
      <commits>100</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2002-09-01T00:00:00Z</month>
      <code_added>0</code_added>
      <code_removed>0</code_removed>
      <comments_added>0</comments_added>
      <comments_removed>0</comments_removed>
      <blanks_added>0</blanks_added>
      <blanks_removed>0</blanks_removed>
      <commits>0</commits>
      <contributors>0</contributors>
    </activity_fact>
    <activity_fact>
      <month>2002-10-01T00:00:00Z</month>
      <code_added>0</code_added>
      <code_removed>0</code_removed>
      <comments_added>0</comments_added>
      <comments_removed>0</comments_removed>
      <blanks_added>0</blanks_added>
      <blanks_removed>0</blanks_removed>
      <commits>0</commits>
      <contributors>0</contributors>
    </activity_fact>
    <activity_fact>
      <month>2002-11-01T00:00:00Z</month>
      <code_added>0</code_added>
      <code_removed>0</code_removed>
      <comments_added>0</comments_added>
      <comments_removed>0</comments_removed>
      <blanks_added>0</blanks_added>
      <blanks_removed>0</blanks_removed>
      <commits>0</commits>
      <contributors>0</contributors>
    </activity_fact>
    <activity_fact>
      <month>2002-12-01T00:00:00Z</month>
      <code_added>7510</code_added>
      <code_removed>2417</code_removed>
      <comments_added>2398</comments_added>
      <comments_removed>307</comments_removed>
      <blanks_added>1559</blanks_added>
      <blanks_removed>81</blanks_removed>
      <commits>4</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-01-01T00:00:00Z</month>
      <code_added>1621</code_added>
      <code_removed>840</code_removed>
      <comments_added>474</comments_added>
      <comments_removed>78</comments_removed>
      <blanks_added>300</blanks_added>
      <blanks_removed>6</blanks_removed>
      <commits>3</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-02-01T00:00:00Z</month>
      <code_added>784</code_added>
      <code_removed>272</code_removed>
      <comments_added>140</comments_added>
      <comments_removed>21</comments_removed>
      <blanks_added>131</blanks_added>
      <blanks_removed>2</blanks_removed>
      <commits>2</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-03-01T00:00:00Z</month>
      <code_added>1056</code_added>
      <code_removed>518</code_removed>
      <comments_added>363</comments_added>
      <comments_removed>90</comments_removed>
      <blanks_added>204</blanks_added>
      <blanks_removed>62</blanks_removed>
      <commits>48</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-04-01T00:00:00Z</month>
      <code_added>895</code_added>
      <code_removed>94</code_removed>
      <comments_added>350</comments_added>
      <comments_removed>7</comments_removed>
      <blanks_added>291</blanks_added>
      <blanks_removed>9</blanks_removed>
      <commits>18</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-05-01T00:00:00Z</month>
      <code_added>309</code_added>
      <code_removed>85</code_removed>
      <comments_added>106</comments_added>
      <comments_removed>12</comments_removed>
      <blanks_added>55</blanks_added>
      <blanks_removed>7</blanks_removed>
      <commits>15</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-06-01T00:00:00Z</month>
      <code_added>52</code_added>
      <code_removed>45</code_removed>
      <comments_added>0</comments_added>
      <comments_removed>0</comments_removed>
      <blanks_added>0</blanks_added>
      <blanks_removed>0</blanks_removed>
      <commits>5</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-07-01T00:00:00Z</month>
      <code_added>25</code_added>
      <code_removed>45</code_removed>
      <comments_added>1</comments_added>
      <comments_removed>2</comments_removed>
      <blanks_added>0</blanks_added>
      <blanks_removed>2</blanks_removed>
      <commits>10</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-08-01T00:00:00Z</month>
      <code_added>10</code_added>
      <code_removed>17</code_removed>
      <comments_added>9</comments_added>
      <comments_removed>1</comments_removed>
      <blanks_added>1</blanks_added>
      <blanks_removed>1</blanks_removed>
      <commits>5</commits>
      <contributors>2</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-09-01T00:00:00Z</month>
      <code_added>36</code_added>
      <code_removed>29</code_removed>
      <comments_added>11</comments_added>
      <comments_removed>7</comments_removed>
      <blanks_added>2</blanks_added>
      <blanks_removed>1</blanks_removed>
      <commits>6</commits>
      <contributors>2</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-10-01T00:00:00Z</month>
      <code_added>5956</code_added>
      <code_removed>602</code_removed>
      <comments_added>1895</comments_added>
      <comments_removed>103</comments_removed>
      <blanks_added>747</blanks_added>
      <blanks_removed>75</blanks_removed>
      <commits>20</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-11-01T00:00:00Z</month>
      <code_added>400</code_added>
      <code_removed>4005</code_removed>
      <comments_added>140</comments_added>
      <comments_removed>900</comments_removed>
      <blanks_added>48</blanks_added>
      <blanks_removed>1061</blanks_removed>
      <commits>15</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2003-12-01T00:00:00Z</month>
      <code_added>892</code_added>
      <code_removed>623</code_removed>
      <comments_added>265</comments_added>
      <comments_removed>139</comments_removed>
      <blanks_added>30</blanks_added>
      <blanks_removed>55</blanks_removed>
      <commits>24</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-01-01T00:00:00Z</month>
      <code_added>974</code_added>
      <code_removed>765</code_removed>
      <comments_added>430</comments_added>
      <comments_removed>164</comments_removed>
      <blanks_added>142</blanks_added>
      <blanks_removed>122</blanks_removed>
      <commits>46</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-02-01T00:00:00Z</month>
      <code_added>604</code_added>
      <code_removed>183</code_removed>
      <comments_added>195</comments_added>
      <comments_removed>19</comments_removed>
      <blanks_added>114</blanks_added>
      <blanks_removed>3</blanks_removed>
      <commits>48</commits>
      <contributors>5</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-03-01T00:00:00Z</month>
      <code_added>414</code_added>
      <code_removed>158</code_removed>
      <comments_added>69</comments_added>
      <comments_removed>35</comments_removed>
      <blanks_added>16</blanks_added>
      <blanks_removed>0</blanks_removed>
      <commits>11</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-04-01T00:00:00Z</month>
      <code_added>114</code_added>
      <code_removed>885</code_removed>
      <comments_added>16</comments_added>
      <comments_removed>23</comments_removed>
      <blanks_added>16</blanks_added>
      <blanks_removed>166</blanks_removed>
      <commits>16</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-05-01T00:00:00Z</month>
      <code_added>206</code_added>
      <code_removed>189</code_removed>
      <comments_added>42</comments_added>
      <comments_removed>22</comments_removed>
      <blanks_added>22</blanks_added>
      <blanks_removed>4</blanks_removed>
      <commits>16</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-06-01T00:00:00Z</month>
      <code_added>635</code_added>
      <code_removed>233</code_removed>
      <comments_added>187</comments_added>
      <comments_removed>15</comments_removed>
      <blanks_added>92</blanks_added>
      <blanks_removed>8</blanks_removed>
      <commits>23</commits>
      <contributors>2</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-07-01T00:00:00Z</month>
      <code_added>37</code_added>
      <code_removed>92</code_removed>
      <comments_added>3</comments_added>
      <comments_removed>30</comments_removed>
      <blanks_added>0</blanks_added>
      <blanks_removed>15</blanks_removed>
      <commits>4</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-08-01T00:00:00Z</month>
      <code_added>6</code_added>
      <code_removed>6</code_removed>
      <comments_added>0</comments_added>
      <comments_removed>0</comments_removed>
      <blanks_added>0</blanks_added>
      <blanks_removed>0</blanks_removed>
      <commits>1</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-09-01T00:00:00Z</month>
      <code_added>945</code_added>
      <code_removed>315</code_removed>
      <comments_added>411</comments_added>
      <comments_removed>22</comments_removed>
      <blanks_added>146</blanks_added>
      <blanks_removed>33</blanks_removed>
      <commits>13</commits>
      <contributors>1</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-10-01T00:00:00Z</month>
      <code_added>538</code_added>
      <code_removed>245</code_removed>
      <comments_added>86</comments_added>
      <comments_removed>20</comments_removed>
      <blanks_added>33</blanks_added>
      <blanks_removed>7</blanks_removed>
      <commits>22</commits>
      <contributors>2</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-11-01T00:00:00Z</month>
      <code_added>413</code_added>
      <code_removed>100</code_removed>
      <comments_added>151</comments_added>
      <comments_removed>38</comments_removed>
      <blanks_added>50</blanks_added>
      <blanks_removed>1</blanks_removed>
      <commits>36</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2004-12-01T00:00:00Z</month>
      <code_added>486</code_added>
      <code_removed>406</code_removed>
      <comments_added>157</comments_added>
      <comments_removed>93</comments_removed>
      <blanks_added>92</blanks_added>
      <blanks_removed>66</blanks_removed>
      <commits>24</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-01-01T00:00:00Z</month>
      <code_added>6012</code_added>
      <code_removed>2891</code_removed>
      <comments_added>1461</comments_added>
      <comments_removed>537</comments_removed>
      <blanks_added>1504</blanks_added>
      <blanks_removed>305</blanks_removed>
      <commits>53</commits>
      <contributors>6</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-02-01T00:00:00Z</month>
      <code_added>603</code_added>
      <code_removed>466</code_removed>
      <comments_added>1842</comments_added>
      <comments_removed>1478</comments_removed>
      <blanks_added>99</blanks_added>
      <blanks_removed>23</blanks_removed>
      <commits>36</commits>
      <contributors>7</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-03-01T00:00:00Z</month>
      <code_added>2072</code_added>
      <code_removed>935</code_removed>
      <comments_added>606</comments_added>
      <comments_removed>142</comments_removed>
      <blanks_added>405</blanks_added>
      <blanks_removed>53</blanks_removed>
      <commits>63</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-04-01T00:00:00Z</month>
      <code_added>1060</code_added>
      <code_removed>510</code_removed>
      <comments_added>307</comments_added>
      <comments_removed>61</comments_removed>
      <blanks_added>168</blanks_added>
      <blanks_removed>14</blanks_removed>
      <commits>42</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-05-01T00:00:00Z</month>
      <code_added>4777</code_added>
      <code_removed>598</code_removed>
      <comments_added>1142</comments_added>
      <comments_removed>81</comments_removed>
      <blanks_added>808</blanks_added>
      <blanks_removed>25</blanks_removed>
      <commits>53</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-06-01T00:00:00Z</month>
      <code_added>489</code_added>
      <code_removed>307</code_removed>
      <comments_added>54</comments_added>
      <comments_removed>32</comments_removed>
      <blanks_added>70</blanks_added>
      <blanks_removed>9</blanks_removed>
      <commits>32</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-07-01T00:00:00Z</month>
      <code_added>765</code_added>
      <code_removed>874</code_removed>
      <comments_added>206</comments_added>
      <comments_removed>252</comments_removed>
      <blanks_added>140</blanks_added>
      <blanks_removed>109</blanks_removed>
      <commits>65</commits>
      <contributors>7</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-08-01T00:00:00Z</month>
      <code_added>1723</code_added>
      <code_removed>1154</code_removed>
      <comments_added>176</comments_added>
      <comments_removed>97</comments_removed>
      <blanks_added>298</blanks_added>
      <blanks_removed>35</blanks_removed>
      <commits>54</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-09-01T00:00:00Z</month>
      <code_added>4193</code_added>
      <code_removed>575</code_removed>
      <comments_added>920</comments_added>
      <comments_removed>47</comments_removed>
      <blanks_added>1162</blanks_added>
      <blanks_removed>59</blanks_removed>
      <commits>49</commits>
      <contributors>5</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-10-01T00:00:00Z</month>
      <code_added>1372</code_added>
      <code_removed>571</code_removed>
      <comments_added>190</comments_added>
      <comments_removed>51</comments_removed>
      <blanks_added>253</blanks_added>
      <blanks_removed>12</blanks_removed>
      <commits>56</commits>
      <contributors>2</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-11-01T00:00:00Z</month>
      <code_added>1196</code_added>
      <code_removed>450</code_removed>
      <comments_added>305</comments_added>
      <comments_removed>67</comments_removed>
      <blanks_added>229</blanks_added>
      <blanks_removed>26</blanks_removed>
      <commits>60</commits>
      <contributors>7</contributors>
    </activity_fact>
    <activity_fact>
      <month>2005-12-01T00:00:00Z</month>
      <code_added>2619</code_added>
      <code_removed>869</code_removed>
      <comments_added>512</comments_added>
      <comments_removed>75</comments_removed>
      <blanks_added>590</blanks_added>
      <blanks_removed>21</blanks_removed>
      <commits>55</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-01-01T00:00:00Z</month>
      <code_added>671</code_added>
      <code_removed>295</code_removed>
      <comments_added>137</comments_added>
      <comments_removed>29</comments_removed>
      <blanks_added>151</blanks_added>
      <blanks_removed>24</blanks_removed>
      <commits>21</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-02-01T00:00:00Z</month>
      <code_added>241</code_added>
      <code_removed>109</code_removed>
      <comments_added>44</comments_added>
      <comments_removed>11</comments_removed>
      <blanks_added>28</blanks_added>
      <blanks_removed>3</blanks_removed>
      <commits>18</commits>
      <contributors>7</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-03-01T00:00:00Z</month>
      <code_added>697</code_added>
      <code_removed>469</code_removed>
      <comments_added>229</comments_added>
      <comments_removed>142</comments_removed>
      <blanks_added>72</blanks_added>
      <blanks_removed>29</blanks_removed>
      <commits>39</commits>
      <contributors>7</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-04-01T00:00:00Z</month>
      <code_added>103</code_added>
      <code_removed>67</code_removed>
      <comments_added>28</comments_added>
      <comments_removed>11</comments_removed>
      <blanks_added>10</blanks_added>
      <blanks_removed>6</blanks_removed>
      <commits>10</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-05-01T00:00:00Z</month>
      <code_added>712</code_added>
      <code_removed>280</code_removed>
      <comments_added>223</comments_added>
      <comments_removed>92</comments_removed>
      <blanks_added>110</blanks_added>
      <blanks_removed>34</blanks_removed>
      <commits>29</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-06-01T00:00:00Z</month>
      <code_added>403</code_added>
      <code_removed>108</code_removed>
      <comments_added>120</comments_added>
      <comments_removed>14</comments_removed>
      <blanks_added>89</blanks_added>
      <blanks_removed>6</blanks_removed>
      <commits>35</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-07-01T00:00:00Z</month>
      <code_added>370</code_added>
      <code_removed>146</code_removed>
      <comments_added>72</comments_added>
      <comments_removed>32</comments_removed>
      <blanks_added>60</blanks_added>
      <blanks_removed>11</blanks_removed>
      <commits>31</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-08-01T00:00:00Z</month>
      <code_added>451</code_added>
      <code_removed>253</code_removed>
      <comments_added>35</comments_added>
      <comments_removed>34</comments_removed>
      <blanks_added>61</blanks_added>
      <blanks_removed>18</blanks_removed>
      <commits>33</commits>
      <contributors>5</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-09-01T00:00:00Z</month>
      <code_added>1666</code_added>
      <code_removed>721</code_removed>
      <comments_added>510</comments_added>
      <comments_removed>66</comments_removed>
      <blanks_added>242</blanks_added>
      <blanks_removed>64</blanks_removed>
      <commits>54</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-10-01T00:00:00Z</month>
      <code_added>1771</code_added>
      <code_removed>1554</code_removed>
      <comments_added>301</comments_added>
      <comments_removed>233</comments_removed>
      <blanks_added>106</blanks_added>
      <blanks_removed>79</blanks_removed>
      <commits>63</commits>
      <contributors>5</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-11-01T00:00:00Z</month>
      <code_added>3053</code_added>
      <code_removed>2842</code_removed>
      <comments_added>618</comments_added>
      <comments_removed>471</comments_removed>
      <blanks_added>374</blanks_added>
      <blanks_removed>300</blanks_removed>
      <commits>55</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2006-12-01T00:00:00Z</month>
      <code_added>1027</code_added>
      <code_removed>389</code_removed>
      <comments_added>164</comments_added>
      <comments_removed>56</comments_removed>
      <blanks_added>126</blanks_added>
      <blanks_removed>22</blanks_removed>
      <commits>39</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-01-01T00:00:00Z</month>
      <code_added>257</code_added>
      <code_removed>111</code_removed>
      <comments_added>74</comments_added>
      <comments_removed>30</comments_removed>
      <blanks_added>43</blanks_added>
      <blanks_removed>13</blanks_removed>
      <commits>15</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-02-01T00:00:00Z</month>
      <code_added>1155</code_added>
      <code_removed>443</code_removed>
      <comments_added>328</comments_added>
      <comments_removed>91</comments_removed>
      <blanks_added>154</blanks_added>
      <blanks_removed>30</blanks_removed>
      <commits>51</commits>
      <contributors>7</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-03-01T00:00:00Z</month>
      <code_added>269</code_added>
      <code_removed>142</code_removed>
      <comments_added>55</comments_added>
      <comments_removed>27</comments_removed>
      <blanks_added>23</blanks_added>
      <blanks_removed>7</blanks_removed>
      <commits>15</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-04-01T00:00:00Z</month>
      <code_added>516</code_added>
      <code_removed>110</code_removed>
      <comments_added>101</comments_added>
      <comments_removed>18</comments_removed>
      <blanks_added>70</blanks_added>
      <blanks_removed>2</blanks_removed>
      <commits>32</commits>
      <contributors>5</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-05-01T00:00:00Z</month>
      <code_added>366</code_added>
      <code_removed>186</code_removed>
      <comments_added>79</comments_added>
      <comments_removed>22</comments_removed>
      <blanks_added>27</blanks_added>
      <blanks_removed>1</blanks_removed>
      <commits>17</commits>
      <contributors>6</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-06-01T00:00:00Z</month>
      <code_added>675</code_added>
      <code_removed>724</code_removed>
      <comments_added>172</comments_added>
      <comments_removed>160</comments_removed>
      <blanks_added>86</blanks_added>
      <blanks_removed>78</blanks_removed>
      <commits>36</commits>
      <contributors>4</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-07-01T00:00:00Z</month>
      <code_added>336</code_added>
      <code_removed>221</code_removed>
      <comments_added>119</comments_added>
      <comments_removed>21</comments_removed>
      <blanks_added>55</blanks_added>
      <blanks_removed>14</blanks_removed>
      <commits>20</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-08-01T00:00:00Z</month>
      <code_added>1836</code_added>
      <code_removed>1746</code_removed>
      <comments_added>820</comments_added>
      <comments_removed>535</comments_removed>
      <blanks_added>365</blanks_added>
      <blanks_removed>384</blanks_removed>
      <commits>55</commits>
      <contributors>6</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-09-01T00:00:00Z</month>
      <code_added>797</code_added>
      <code_removed>415</code_removed>
      <comments_added>191</comments_added>
      <comments_removed>47</comments_removed>
      <blanks_added>132</blanks_added>
      <blanks_removed>45</blanks_removed>
      <commits>14</commits>
      <contributors>2</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-10-01T00:00:00Z</month>
      <code_added>3371</code_added>
      <code_removed>645</code_removed>
      <comments_added>756</comments_added>
      <comments_removed>199</comments_removed>
      <blanks_added>885</blanks_added>
      <blanks_removed>51</blanks_removed>
      <commits>30</commits>
      <contributors>6</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-11-01T00:00:00Z</month>
      <code_added>308</code_added>
      <code_removed>91</code_removed>
      <comments_added>56</comments_added>
      <comments_removed>31</comments_removed>
      <blanks_added>33</blanks_added>
      <blanks_removed>4</blanks_removed>
      <commits>25</commits>
      <contributors>3</contributors>
    </activity_fact>
    <activity_fact>
      <month>2007-12-01T00:00:00Z</month>
      <code_added>2119</code_added>
      <code_removed>2212</code_removed>
      <comments_added>1060</comments_added>
      <comments_removed>753</comments_removed>
      <blanks_added>446</blanks_added>
      <blanks_removed>395</blanks_removed>
      <commits>51</commits>
      <contributors>5</contributors>
    </activity_fact>
    <activity_fact>
      <month>2008-01-01T00:00:00Z</month>
      <code_added>3078</code_added>
      <code_removed>1555</code_removed>
      <comments_added>985</comments_added>
      <comments_removed>282</comments_removed>
      <blanks_added>486</blanks_added>
      <blanks_removed>98</blanks_removed>
      <commits>51</commits>
      <contributors>3</contributors>
    </activity_fact>
  </result>
</response>
