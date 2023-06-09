
#Область Обработчики_событий_формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ИсторияВыполнения.Параметры.УстановитьЗначениеПараметра("КонтрольнаяПроцедура", Объект.Ссылка);
    ИсторияВыполнения.Параметры.УстановитьЗначениеПараметра("ОбъектКонтроля", Объект.ОбъектКонтроля);
    
    ЭтотОбъект.Справка = Общий.ТекстHTMLМакета(Объект.Владелец.ИмяБизнесПроцесса);
    
    ЗагрузитьНастройки();
    ЗаполнитьПараметрыИнцидентов();
        
    Если Объект.ОбъектКонтроля.ПлощадкаЭксплуатации.ПометкаУдаления ИЛИ Объект.ОбъектКонтроля.ПлощадкаЭксплуатации = Справочники.ПлощадкиЭксплуатации.Корзина() Тогда
        ЭтотОбъект.ТолькоПросмотр = Истина;
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    УстановитьДоступностьКомандУправления();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
    
    НастройкаВыполнена = Истина;
    Сохранено = Истина;
    
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
    ЗаписатьНастройки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КаталогЗапускаКлиентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    ОписаниеОповещениеЗавершение = Новый ОписаниеОповещения("ОбработкаНачалоВыбораЗавершение", ЭтотОбъект, Элемент);
	ОбщийКлиент.ВыбратьФайл(ЭтотОбъект[Элемент.Имя], "1cestart.exe|1cestart.exe", ОписаниеОповещениеЗавершение);
    
КонецПроцедуры

#КонецОбласти

#Область Обработчики_команд_формы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
    
    ЭтотОбъект.Записать();
	ЭтотОбъект.Закрыть();
    
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
    ЭтотОбъект.Записать();
КонецПроцедуры

&НаКлиенте
Процедура Старт(Команда)
    
    Объект.Выполнять = Истина;
    Объект.Пауза = Ложь;
    УстановитьДоступностьКомандУправления();
    ЭтотОбъект.Записать();
    
КонецПроцедуры

&НаКлиенте
Процедура Пауза(Команда)
    
    Объект.Выполнять = Истина;
    Объект.Пауза = Истина;
    УстановитьДоступностьКомандУправления();
    ЭтотОбъект.Записать();
    
КонецПроцедуры

&НаКлиенте
Процедура Стоп(Команда)
    
    Объект.Выполнять = Ложь;
    Объект.Пауза = Ложь;
    УстановитьДоступностьКомандУправления();
    ЭтотОбъект.Записать();
    
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСейчас(Команда)
    ВыполнитьСейчасНаСервере(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
    
    ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	РасписаниеКлиент.НастроитьРасписаниеПоложитьВоВременноеХранилище(ОписаниеОповещения);
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ВыполнитьСейчасНаСервере(КонтрольнаяПроцедураСсылка)
    УправлениеЗаданиямиСервер.ЗапускКонтрольнойПроцедуры(КонтрольнаяПроцедураСсылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройки()
    
    Настройки = Справочники.КонтрольныеПроцедуры.ПолучитьНастройкиКонтроляРегламентныхЗаданий(Объект.Ссылка);
    Если Настройки <> Неопределено Тогда
        ЭтотОбъект.КаталогЗапускаКлиента = Настройки.КаталогЗапускаКлиента;
        ЭтотОбъект.ДопустимаяДлительностьВыполнения = Настройки.ДопустимаяДлительностьВыполнения;
    КонецЕсли;
    
    РасписаниеПоУмолчанию = РасписаниеСервер.ПолучитьРасписание(Объект.Ссылка); 
	ЭтотОбъект.РасписаниеЗадания = РасписаниеПоУмолчанию;
	ЭтотОбъект.РасписаниеСтрока = Строка(РасписаниеПоУмолчанию);
	АдресВременногоХранилищаРасписания = ПоместитьВоВременноеХранилище(РасписаниеПоУмолчанию, ЭтотОбъект.УникальныйИдентификатор);
    
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройки()
    
    МенеджерЗаписи = РегистрыСведений.НастройкиКонтрольРегламентныхЗаданий.СоздатьМенеджерЗаписи();
    МенеджерЗаписи.КонтрольнаяПроцедура = Объект.Ссылка;
    МенеджерЗаписи.Прочитать();
    
    МенеджерЗаписи.ДопустимаяДлительностьВыполнения = ЭтотОбъект.ДопустимаяДлительностьВыполнения;
    МенеджерЗаписи.КаталогЗапускаКлиента = ЭтотОбъект.КаталогЗапускаКлиента;
    МенеджерЗаписи.Записать(Истина);
    
    РасписаниеСервер.СохранитьРасписание(ЭтотОбъект, Объект.Ссылка, ЭтотОбъект.АдресВременногоХранилищаРасписания);
    
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Адрес, ДополнительныеПараметры) Экспорт
    
    Если Адрес <> Неопределено Тогда
		АдресВременногоХранилищаРасписания = Адрес;
    КонецЕсли;		
    
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандУправления()
    
    Если Объект.Выполнять = Ложь И Объект.Пауза = Ложь Тогда
        ЭтотОбъект.Элементы.Старт.Доступность = Истина;
        ЭтотОбъект.Элементы.Пауза.Доступность = Ложь;
        ЭтотОбъект.Элементы.Стоп.Доступность = Ложь;
    ИначеЕсли Объект.Выполнять = Истина И Объект.Пауза = Ложь Тогда
        ЭтотОбъект.Элементы.Старт.Доступность = Ложь;
        ЭтотОбъект.Элементы.Пауза.Доступность = Истина;
        ЭтотОбъект.Элементы.Стоп.Доступность = Истина;        
    ИначеЕсли Объект.Выполнять = Истина И Объект.Пауза = Истина Тогда
        ЭтотОбъект.Элементы.Старт.Доступность = Истина;
        ЭтотОбъект.Элементы.Пауза.Доступность = Ложь;
        ЭтотОбъект.Элементы.Стоп.Доступность = Истина;        
    КонецЕсли;
    
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыИнцидентов()
    
    ПараметрыИнцидентаСтоп = Справочники.КонтрольныеПроцедуры.ПолучитьПараметрыИнцидентаКонтрольВыполненияРегламентныхЗаданий(Объект.Ссылка, Справочники.ТипыЗадачКонтрольРегламентныхЗаданий.КонтрольРегламентныхЗаданийНетСобытий);
	НовСтрока = ЭтотОбъект.ПараметрыИнцидентов.Добавить();
	НовСтрока.ТипИнцидента = ПараметрыИнцидентаСтоп.НаименованиеТипаИнцидента;
	НовСтрока.КодИнцидента = ПараметрыИнцидентаСтоп.КодИнцидента;
	
	ПараметрыИнцидентаТаймаут = Справочники.КонтрольныеПроцедуры.ПолучитьПараметрыИнцидентаКонтрольВыполненияРегламентныхЗаданий(Объект.Ссылка, Справочники.ТипыЗадачКонтрольРегламентныхЗаданий.КонтрольРегламентныхЗаданийТаймаут);
	НовСтрока = ЭтотОбъект.ПараметрыИнцидентов.Добавить();
	НовСтрока.ТипИнцидента = ПараметрыИнцидентаТаймаут.НаименованиеТипаИнцидента;
	НовСтрока.КодИнцидента = ПараметрыИнцидентаТаймаут.КодИнцидента;
    
    ПараметрыИнцидентаОшибка = Справочники.КонтрольныеПроцедуры.ПолучитьПараметрыИнцидентаКонтрольВыполненияРегламентныхЗаданий(Объект.Ссылка, Справочники.ТипыЗадачКонтрольРегламентныхЗаданий.КонтрольРегламентныхЗаданийОшибка);
	НовСтрока = ЭтотОбъект.ПараметрыИнцидентов.Добавить();
	НовСтрока.ТипИнцидента = ПараметрыИнцидентаОшибка.НаименованиеТипаИнцидента;
	НовСтрока.КодИнцидента = ПараметрыИнцидентаОшибка.КодИнцидента;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ЭтотОбъект[ДополнительныеПараметры.Имя] = ВыбранныеФайлы[0];
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти