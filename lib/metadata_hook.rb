class PrologMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'prolog',
        icon: {type: 'devicon', name: 'prolog'},
        version: 'swi-prolog 6.6.4',
        extension: 'pl',
        ace_mode: 'prolog',
        prompt: '?'
    },
     test_framework: {
         name: 'plunit',
         test_extension: 'pl',
         template: <<prolog
test(test_description_example):-
	aPredicate(anIndividual).
prolog
     }}
  end
end