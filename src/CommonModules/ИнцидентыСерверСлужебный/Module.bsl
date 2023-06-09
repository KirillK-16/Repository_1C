#Область СлужебныеПроцедурыИФункции

Процедура АвтоДобавлениеПоказателейВОбнаружение() Экспорт
    
    Общий.ПриНачалеВыполненияРегламентногоЗадания();
    
    Справочники.ОбнаружениеИнцидентов.ВыполнитьАвтоДобавлениеПоказателей();
    Справочники.ОбнаружениеИнцидентовОперативное.ВыполнитьАвтоДобавлениеПоказателей();
    
КонецПроцедуры

Процедура ЗакрытьПринудительноВсеНаСервереВФоне(ПараметрыЗапуска) Экспорт
    
    Инциденты = ПараметрыЗапуска.Инциденты;
    Все = ПараметрыЗапуска.Все;
    
    Для Каждого ТекИнцидент Из Инциденты Цикл
        Если Все Тогда
            ИнцидентыСервер.УказатьНовыйСтатусДляИнцидента(ТекИнцидент.Инцидент, ТекИнцидент.ТипИнцидента, Перечисления.СтатусыИнцидентов.Закрыто,,,0);
        Иначе
            Если ТекИнцидент.Статус = Перечисления.СтатусыИнцидентов.Неактуальный Тогда
                ИнцидентыСервер.УказатьНовыйСтатусДляИнцидента(ТекИнцидент.Инцидент, ТекИнцидент.ТипИнцидента, Перечисления.СтатусыИнцидентов.Закрыто,,,0);
            КонецЕсли;
        КонецЕсли;
    КонецЦикла;
    
КонецПроцедуры

#КонецОбласти