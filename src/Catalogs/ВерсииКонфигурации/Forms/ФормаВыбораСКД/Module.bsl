
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ЭтотОбъект.ИспользоватьПериод = Истина;
    ЭтотОбъект.ИспользоватьКонфигурацию = Истина;
	ЭтотОбъект.ИспользоватьРелизная = Истина;
    
    ЭтотОбъект.Период = ЭтотОбъект.Параметры.Период;
    ЭтотОбъект.Конфигурация = ЭтотОбъект.Параметры.Конфигурация;
	ЭтотОбъект.Релизная = Истина;
	
	ЭтотОбъект.Элементы.ГруппаОтборПериод.Доступность = Истина;
    ЭтотОбъект.Элементы.ГруппаОтборКонфигурация.Доступность = Истина;
	ЭтотОбъект.Элементы.ГруппаОтборРелизная.Доступность = Истина;
	ЭтотОбъект.ИспользоватьОтбор = Истина;
	
	ПараметрыОтбора = Новый Структура;
    ПараметрыОтбора.Вставить("Период", ЭтотОбъект.Период);
    ПараметрыОтбора.Вставить("Конфигурация", ЭтотОбъект.Конфигурация);
	ПараметрыОтбора.Вставить("Релизная", ЭтотОбъект.Релизная);
	ПараметрыОтбора.Вставить("ИспользоватьРелизная", ЭтотОбъект.ИспользоватьРелизная);
    
    
    ОбновитьОтборНаСервере(ПараметрыОтбора);
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьОтбор()
	
	ПараметрыОтбора = Новый Структура;
    Если ЭтотОбъект.ИспользоватьОтбор Тогда
        ПараметрыОтбора.Вставить("Период", ЭтотОбъект.Период);
        ПараметрыОтбора.Вставить("Конфигурация", ЭтотОбъект.Конфигурация);
		ПараметрыОтбора.Вставить("Релизная", ЭтотОбъект.Релизная);
		ПараметрыОтбора.Вставить("ИспользоватьРелизная", ЭтотОбъект.ИспользоватьРелизная);
    КонецЕсли;
    
    ОбновитьОтборНаСервере(ПараметрыОтбора);

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПриИзменении(Элемент)
    
    ЭтотОбъект.Элементы.ГруппаОтборПериод.Доступность = ЭтотОбъект.ИспользоватьПериод;
    ЭтотОбъект.Элементы.ГруппаОтборКонфигурация.Доступность = ЭтотОбъект.ИспользоватьПериод;
	ЭтотОбъект.Элементы.ГруппаОтборРелизная.Доступность = ЭтотОбъект.ИспользоватьПериод;
	
	ОбновитьОтбор();
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьОтборНаСервере(ПараметрыОтбора)
    
    Если ПараметрыОтбора.Количество() > 0 Тогда
        Список.ПроизвольныйЗапрос = Истина;
        ТекстЗапроса = Общий.ТекстЗапросаПериодов(ПараметрыОтбора.Период.ДатаНачала, ПараметрыОтбора.Период.ДатаОкончания, "День");
		Список.ТекстЗапроса = ТекстЗапроса + ";
        |ВЫБРАТЬ
	    |   СправочникВерсииКонфигурации.Ссылка,
	    |   СправочникВерсииКонфигурации.ПометкаУдаления,
	    |   СправочникВерсииКонфигурации.Наименование,
	    |   СправочникВерсииКонфигурации.ВерсияЧисло,
	    |   СправочникВерсииКонфигурации.Предопределенный,
	    |   СправочникВерсииКонфигурации.ИмяПредопределенныхДанных,
		|   СправочникВерсииКонфигурации.Релизная,
        |   КОЛИЧЕСТВО(РАЗЛИЧНЫЕ История.ИнформационнаяБаза) КАК КоличествоИБ
        |ИЗ
	    |   Справочник.ВерсииКонфигурации КАК СправочникВерсииКонфигурации
        |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
        |   РегистрСведений.ИнформацияИсторияПодробно КАК История
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ Периоды КАК Периоды
		|	ПО Периоды.Период = История.ПериодЗаписи
        |ПО
        |   История.Конфигурация = &Конфигурация
        |   И История.ВерсияКонфигурации = СправочникВерсииКонфигурации.Ссылка
		|	И Выбор Когда &ИспользоватьРелизная Тогда СправочникВерсииКонфигурации.Релизная = &Релизная Иначе Истина Конец
        |СГРУППИРОВАТЬ ПО
        |   СправочникВерсииКонфигурации.Ссылка,
	    |   СправочникВерсииКонфигурации.ПометкаУдаления,
	    |   СправочникВерсииКонфигурации.Наименование,
	    |   СправочникВерсииКонфигурации.ВерсияЧисло,
	    |   СправочникВерсииКонфигурации.Предопределенный,
		|   СправочникВерсииКонфигурации.Релизная,
	    |   СправочникВерсииКонфигурации.ИмяПредопределенныхДанных
        |";
        
        ПараметрДатаНачала = Список.Параметры.Элементы.Найти("ДатаНачала");
        ПараметрДатаНачала.Использование = Истина;
        ПараметрДатаНачала.Значение = Дата(ПараметрыОтбора.Период.ДатаНачала);
        
        ПараметрДатаОкончания = Список.Параметры.Элементы.Найти("ДатаОкончания");
        ПараметрДатаОкончания.Использование = Истина;
        ПараметрДатаОкончания.Значение = Дата(ПараметрыОтбора.Период.ДатаОкончания);
        
        ПараметрКонфигурация = Список.Параметры.Элементы.Найти("Конфигурация");
        ПараметрКонфигурация.Использование = Истина;
        ПараметрКонфигурация.Значение = ПараметрыОтбора.Конфигурация;
		
		ПараметрРелизная = Список.Параметры.Элементы.Найти("Релизная");
        ПараметрРелизная.Использование = Истина;
        ПараметрРелизная.Значение = ПараметрыОтбора.Релизная;
		
		ПараметрРелизная = Список.Параметры.Элементы.Найти("ИспользоватьРелизная");
        ПараметрРелизная.Использование = Истина;
        ПараметрРелизная.Значение = ПараметрыОтбора.ИспользоватьРелизная;
        
        ЭтотОбъект.Элементы.КоличествоИБ.Видимость = Истина;
    Иначе
        Список.ТекстЗапроса = "
        |ВЫБРАТЬ
	    |   СправочникВерсииКонфигурации.Ссылка,
	    |   СправочникВерсииКонфигурации.ПометкаУдаления,
	    |   СправочникВерсииКонфигурации.Наименование,
	    |   СправочникВерсииКонфигурации.ВерсияЧисло,
	    |   СправочникВерсииКонфигурации.Предопределенный,
	    |   СправочникВерсииКонфигурации.ИмяПредопределенныхДанных,
		|   СправочникВерсииКонфигурации.Релизная,
	    |   0 КАК КоличествоИБ
        |ИЗ
	    |   Справочник.ВерсииКонфигурации КАК СправочникВерсииКонфигурации
        |";
        
        ЭтотОбъект.Элементы.КоличествоИБ.Видимость = Ложь;
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ОбновитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура КонфигурацияПриИзменении(Элемент)
	ОбновитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура РелизнаяПриИзменении(Элемент)
	ОбновитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРелизнаяПриИзменении(Элемент)
	ОбновитьОтбор();
КонецПроцедуры

#КонецОбласти
