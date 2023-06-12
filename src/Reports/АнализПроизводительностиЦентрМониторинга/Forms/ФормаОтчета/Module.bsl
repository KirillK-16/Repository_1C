
&НаКлиенте
Перем ПроверкаВыполненияФоновогоЗаданияСчетчик, ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    ЭтотОбъект.КлючУникальности = Новый УникальныйИдентификатор();
КонецПроцедуры

&НаСервере
Процедура ПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
    СоздатьЭлементыФормыПользовательскихНастроек();
    
    ЭлементВерсияКонфигурации = ФункцииСКД.НайтиЭлементПользовательскойНастройки(ЭтотОбъект.Элементы.КомпоновщикНастроекПользовательскиеНастройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, Новый ПараметрКомпоновкиДанных("ВерсияКонфигурации"));
    
    Если ЭлементВерсияКонфигурации <> Неопределено Тогда
        ЭлементВерсияКонфигурации.УстановитьДействие("НачалоВыбора", "ПрограммноВерсияКонфигурацииНачалоВыбора");
        ЭлементВерсияКонфигурации.УстановитьДействие("ОбработкаВыбора", "ПрограммноВерсияКонфигурацииОбработкаВыбора");
    КонецЕсли;
        
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПрограммноВерсияКонфигурацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
    
    ИдентификаторПользовательскойНастройки = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период")).ИдентификаторПользовательскойНастройки;
    ПараметрПериод = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдентификаторПользовательскойНастройки);
    
    ИдентификаторПользовательскойНастройки = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Конфигурация")).ИдентификаторПользовательскойНастройки;
    ПараметрКонфигурация = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдентификаторПользовательскойНастройки);
    
    ПараметрыОткрытия = Новый Структура;
    ПараметрыОткрытия.Вставить("Период", ПараметрПериод.Значение);
    ПараметрыОткрытия.Вставить("Конфигурация", ПараметрКонфигурация.Значение);
    ФормаВыбора = ОткрытьФорму("Справочник.ВерсииКонфигурации.Форма.ФормаВыбораСКД", ПараметрыОткрытия, Элемент);
        
КонецПроцедуры

&НаКлиенте
Процедура ПрограммноВерсияКонфигурацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
    
    ИдентификаторПользовательскойНастройки = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВерсияКонфигурации")).ИдентификаторПользовательскойНастройки;
    ПараметрВерсияКонфигурации = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдентификаторПользовательскойНастройки);
    
    Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ВерсииКонфигурации") Тогда
        ПараметрВерсияКонфигурации.Значение = ВыбранноеЗначение;
    ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
        СписокЗначений = Новый СписокЗначений;
        Для Каждого ТекЭлемент Из ВыбранноеЗначение Цикл
            СписокЗначений.Добавить(ТекЭлемент);
        КонецЦикла;
        ПараметрВерсияКонфигурации.Значение = СписокЗначений;
        ПараметрВерсияКонфигурации.Использование = Истина;
    КонецЕсли;
        
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьПереопределенная(Команда)
    
    ПроверкаВыполненияФоновогоЗаданияСчетчик = 0;
    
    Отчет.АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ЭтотОбъект.УникальныйИдентификатор);
    ЭтотОбъект.СкомпоноватьРезультат(РежимКомпоновкиРезультата.Фоновый);
    
    ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, Отчет.ИдентификаторФоновогоЗадания);
    
    ПодключитьОбработчикОжидания("ПроверкаЗавершенияФормированияОтчета", 1, Истина);
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверкаЗавершенияФормированияОтчета()
    
    РезультатПроверки = ПроверкаЗавершенияФормированияОтчетаНаСервере(Отчет.ИдентификаторФоновогоЗадания, Отчет.АдресХранилища, ЭтотОбъект.УникальныйИдентификатор);
    
    Если РезультатПроверки.Состояние <> "Активно" Тогда
        Если РезультатПроверки.Состояние = "Завершено" Тогда
            ПроверкаВыполненияФоновогоЗаданияСчетчик = 0;
            ЭтотОбъект.Результат = РезультатПроверки.Данные.ДокументРезультат;
            ЭтотОбъект.ДанныеРасшифровки = РезультатПроверки.Данные.ДанныеРасшифровки;
            
            ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
        Иначе
            ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
            Сообщить(РезультатПроверки.Данные);
        КонецЕсли;
    Иначе
        ПроверкаВыполненияФоновогоЗаданияСчетчик = ПроверкаВыполненияФоновогоЗаданияСчетчик + 1;
        Если ПроверкаВыполненияФоновогоЗаданияСчетчик < 5 Тогда
            ПодключитьОбработчикОжидания("ПроверкаЗавершенияФормированияОтчета", 1, Истина);
        ИначеЕсли ПроверкаВыполненияФоновогоЗаданияСчетчик < 10 Тогда
            ПодключитьОбработчикОжидания("ПроверкаЗавершенияФормированияОтчета", 2, Истина);
        Иначе
            ПодключитьОбработчикОжидания("ПроверкаЗавершенияФормированияОтчета", 5, Истина);
        КонецЕсли;
    КонецЕсли;
    
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверкаЗавершенияФормированияОтчетаНаСервере(ИдентификаторФоновогоЗадания, АдресХранилища, УникальныйИдентфикаторФормы)
    
    ФЗ = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторФоновогоЗадания);
	
	Результат = Новый Структура("Состояние, Данные", Неопределено, Новый Структура);
		
	Если ФЗ.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Результат.Состояние = "Активно";
	ИначеЕсли ФЗ.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
		Результат.Состояние = "Завершено";
        
        ДанныеБуфер = ПолучитьИзВременногоХранилища(АдресХранилища);
        Результат.Данные.Вставить("ДокументРезультат", ДанныеБуфер.ДокументРезультат);
        Результат.Данные.Вставить("ДанныеРасшифровки", ПоместитьВоВременноеХранилище(ДанныеБуфер.ДанныеРасшифровки, УникальныйИдентфикаторФормы));
	Иначе
		Результат.Состояние = "Ошибка";
        Результат.Данные = ПодробноеПредставлениеОшибки(ФЗ.ИнформацияОбОшибке);
	КонецЕсли;
	
	Возврат Результат;
    
КонецФункции

#КонецОбласти
