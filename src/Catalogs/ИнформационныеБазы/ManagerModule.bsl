#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция СоздатьЭлементПоУникальномуИдентификатору(УникальныйИдентификатор, НомерПакета, ПостоянныйИдентификатор = "") Экспорт
    
    НовыйЭлемент = Справочники.ИнформационныеБазы.СоздатьЭлемент();
	НовыйЭлемент.Наименование = УникальныйИдентификатор;
	НовыйЭлемент.УникальныйИдентификатор = УникальныйИдентификатор;
	НовыйЭлемент.УникальныйИдентификаторПостоянный = ПостоянныйИдентификатор;
	НовыйЭлемент.НомерПакета = Число(НомерПакета);
	НовыйЭлемент.УстановитьСсылкуНового(Справочники.ИнформационныеБазы.ПолучитьСсылку(Новый УникальныйИдентификатор(УникальныйИдентификатор)));
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент.Ссылка;
    
КонецФункции

Функция ПроверитьКоллизию(Ссылка, НомерПакетаВБазе, НомерПакетаНовый) Экспорт
    
    СпрОбъект = Ссылка.ПолучитьОбъект();
    НомерПакетаЧисло = Число(НомерПакетаНовый);
    Если НомерПакетаЧисло <= НомерПакетаВБазе Тогда
        СпрОбъект.ЕстьКопии = Истина;
    Иначе
        СпрОбъект.НомерПакета = НомерПакетаЧисло;
    КонецЕсли;
    СпрОбъект.Записать();
        
КонецФункции

Процедура УстановитьПостоянныйУникальныйИдентификатор(Ссылка, ПостоянныйИдентификатор) Экспорт
	СпрОбъект = Ссылка.ПолучитьОбъект();
	СпрОбъект.УникальныйИдентификаторПостоянный = ПостоянныйИдентификатор;
	СпрОбъект.Записать();
КонецПроцедуры

#КонецЕсли