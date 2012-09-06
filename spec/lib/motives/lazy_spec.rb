# require 'spec_helper'
# 
# describe Motivation::Motives::Lazy do
#   subject do
#     Motivation::Mote.new name: 'lazy_mote',
#       motives: [described_class]
#   end
# 
#   it "defaults to lazy = false" do
#     subject.lazy.should be_false
#   end
# 
#   context "mote(lazy: true)" do
#     before do
#       subject.lazy = true
#     end
# 
#     describe "#prepare!" do
#       it "does not require the mote" do
#         dont_allow(subject).require!
#         subject.prepare!
#       end
#     end
# 
#     describe "#constant" do
#       it "requires the mote" do
#         mock(subject).require!
#         subject.constant
#       end
#     end
#   end
# 
#   context "mote(lazy: false)" do
#     before do
#       subject.lazy = false
#     end
# 
#     describe "#prepare!" do
#       it "requires the mote" do
#         mock(subject).require!
#         subject.prepare!
#       end
#     end
#   end
# end
