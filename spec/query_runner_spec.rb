require_relative 'spec_helper'
require 'ostruct'
require_relative '../lib/query_runner'

describe QueryRunner do

  let(:query_runner) { QueryRunner.new({swipl_command: 'swipl'}) }
  let(:ostruct_request) { OpenStruct.new(request) }

  context 'true predicate should out true.' do
    let(:request) { {query: 'true.'} }
    it { expect(query_runner.run_query! ostruct_request).to eq(["true.\n", :passed]) }
  end

  context 'fail predicate should out false.' do
    let(:request) { {query: 'fail.'} }
    it { expect(query_runner.run_query! ostruct_request).to eq(["false.\n", :passed]) }
  end

  context 'between 1 and 3 should out X=1; X=2; X=3.' do
    let(:request) { {query: 'between(1,3,X).'} }
    it { expect(query_runner.run_query! ostruct_request).to eq(["X = 1 ;\nX = 2 ;\nX = 3.\n", :passed]) }
  end

  describe 'with monstruos Tp' do
    let(:monsters_extra) {
      'viveEn(dracula, castillo).
viveEn(godzilla, espacio).
viveEn(sullivan, espacio).
viveEn(mLegrand, tv).
viveEn(frankenstein, castillo).
viveEn(barney, tv).
viveEn(allien, espacio).
'}

    let(:monsters_content) {
      "maneja(godzilla, auto(4)).
maneja(barney, colectivo(fucsia,10,5)).
maneja(sullivan, nave([2,3,1])).
maneja(allien, nave([3,4])).

puedeLlevar(Monstruo1, Monstruo2):-
	viveEn(Monstruo1, Lugar),
	viveEn(Monstruo2, Lugar),
	Monstruo1 \\= Monstruo2,
	maneja(Monstruo1, _).
"
    }

    let(:driver_passenger_possibilities) {
      "Conductor = godzilla,
Pasajero = sullivan ;
Conductor = godzilla,
Pasajero = allien ;
Conductor = sullivan,
Pasajero = godzilla ;
Conductor = sullivan,
Pasajero = allien ;
Conductor = barney,
Pasajero = mLegrand ;
Conductor = allien,
Pasajero = godzilla ;
Conductor = allien,
Pasajero = sullivan.
"
    }

    context 'with monstruos Tp should puedeLlevar(barney,Pasajero). out Pasajero=mLegrand' do
      let(:request) { {content: monsters_content, extra: monsters_extra, query: 'puedeLlevar(barney,Pasajero).'} }
      it { expect(query_runner.run_query! ostruct_request).to eq(["Pasajero = mLegrand.\n", :passed]) }
    end

    context 'with monstruos Tp should puedeLlevar(Conductor,Pasajero). out all the possibilities' do
      let(:request) { {content: monsters_content, extra: monsters_extra, query: 'puedeLlevar(Conductor,Pasajero).'} }
      it { expect(query_runner.run_query! ostruct_request).to eq([driver_passenger_possibilities, :passed]) }
    end

  end



end