class MetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'prolog',
        icon: {type: 'devicon', name: 'prolog'},
        version: 'swi-prolog 6.6.4',
        extension: 'pl',
        ace_mode: 'prolog'
    },
     test_framework: {
         name: 'plunit',
         test_extension: 'pl'
     }}
  end
end