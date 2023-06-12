&НаКлиенте
Перем ПеретаскиваемыйШаблон, НачалоЗамера;

&НаКлиенте
Перем ПередЗаписьюВопрос;

&НаКлиенте
Процедура ВидимостьФорматированныйДокументКлиент(Парам)
	Если ЭтотОбъект.ВерсияПлатформы > 8000300000000000 Тогда
		Если Парам Тогда
			ЭтотОбъект.НастройкаФорматированныйДокумент.Удалить();
			ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.НастройкаФорматированныйДокумент, Объект.Настройка);
		КонецЕсли;
		ЭтотОбъект.Элементы.НастройкаФорматированныйДокумент.Видимость  = Парам;
		ЭтотОбъект.Элементы.Группа1.Видимость = Парам;
	Иначе
		ЭтотОбъект.Элементы.Настройка.Видимость = Парам;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьВыбранныеШаблоныКлиент(Парам)
	ЭтотОбъект.Элементы.ШаблоныТЖВыбранные.Видимость = Парам;
КонецПроцедуры

&НаСервере
Процедура ВидимостьФорматированныйДокументСервер(Парам)
	Если ЭтотОбъект.ВерсияПлатформы > 8000300000000000 Тогда
		Если Парам Тогда
			ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.НастройкаФорматированныйДокумент, Объект.Настройка);
		КонецЕсли;
		ЭтотОбъект.Элементы.НастройкаФорматированныйДокумент.Видимость  = Парам;
		ЭтотОбъект.Элементы.Группа1.Видимость = Парам;
	Иначе
		ЭтотОбъект.Элементы.Настройка.Видимость = Парам;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВидимостьВыбранныеШаблоныСервер(Парам)
	ЭтотОбъект.Элементы.ШаблоныТЖВыбранные.Видимость = Парам;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтотОбъект.ВерсияПлатформы = ПараметрыСеанса.ВерсияПлатформы;
	
	ЭтотОбъект.Элементы.ЭкспортДанных.Видимость = Константы.ОтправлятьДанныеВнешнимЦКК.Получить();
	
	Если Объект.Ссылка = Справочники.ТехнологическиеЖурналы.ПустаяСсылка() Тогда
		СсылкаНов = Справочники.ТехнологическиеЖурналы.ПолучитьСсылку(Новый УникальныйИдентификатор());
		МойОбъект = РеквизитФормыВЗначение("Объект");
		МойОбъект.УстановитьСсылкуНового(СсылкаНов);
		
		МойОбъект.Наименование = Справочники.ТехнологическиеЖурналы.ПолучитьНаименованиеНовогоЭлемента();
		МойОбъект.КаталогНастройкиТЖ = ПутьККонфигурационномуФайлу();
		ЭтотОбъект.СсылкаОбъекта = МойОбъект.ПолучитьСсылкуНового();
		
		ЗначениеВРеквизитФормы(МойОбъект, "Объект");
	Иначе
		ЭтотОбъект.СсылкаОбъекта = Объект.Ссылка;
	КонецЕсли;
	ЭтотОбъект.ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	Если Объект.ПроизвольныйТекстНастройки Тогда
		ВидимостьФорматированныйДокументСервер(Истина);
		ВидимостьВыбранныеШаблоныСервер(Ложь);
	Иначе
		ВидимостьФорматированныйДокументСервер(Ложь);
		ВидимостьВыбранныеШаблоныСервер(Истина);
	КонецЕсли;
		
	ЗаполнитьШаблоны();
	//ЗагрузитьТекущийФайлНастроек();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШаблоны()
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТехнологическиеЖурналыШаблоны.Ссылка КАК Ссылка,
	|	ТехнологическиеЖурналыШаблоны.Наименование КАК Наименование,
	|	ТехнологическиеЖурналыШаблоны.Шаблон КАК Шаблон
	|ИЗ
	|	Справочник.ТехнологическиеЖурналыШаблоны КАК ТехнологическиеЖурналыШаблоны
	|ГДЕ
	|	ТехнологическиеЖурналыШаблоны.ПометкаУдаления = Ложь
	|УПОРЯДОЧИТЬ ПО
	|	ТехнологическиеЖурналыШаблоны.Наименование
	|";
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ЭтотОбъект.ШаблоныТЖ.Добавить();
		НоваяСтрока.Ссылка = Выборка.Ссылка;
		НоваяСтрока.Наименование = Выборка.Наименование;
		НоваяСтрока.Шаблон = Выборка.Шаблон;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекущийФайлНастроек(КаталогНастроек, Отключен)
	Результат = Новый Структура;
	
	Если Прав(КаталогНастроек, 1) <> "\" Тогда
		КаталогНастроек = КаталогНастроек + "\";
	КонецЕсли;
	
	//Если НЕ Отключен Тогда
		ФайлНастроек = Новый Файл(КаталогНастроек + "logcfg.xml");
	//Иначе
	//	ФайлНастроек = Новый Файл(КаталогНастроек + "logcfg_off.xml");
	//КонецЕсли;
	
	Если ФайлНастроек.Существует() Тогда
		ЧтениеТекст = Новый ЧтениеТекста(ФайлНастроек.ПолноеИмя);
		НастройкиТекст = ЧтениеТекст.Прочитать();
		ЧтениеТекст.Закрыть();
		
		Результат.Вставить("НастройкиТекст", НастройкиТекст);
		Результат.Вставить("ОшибкаЧтения", Ложь);
	Иначе
		НастройкиТекст = "Ошибка открытия файла: " + ФайлНастроек.ПолноеИмя + Символы.ПС;
		
		Результат.Вставить("НастройкиТекст", НастройкиТекст);
		Результат.Вставить("ОшибкаЧтения", Истина);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции


&НаКлиенте
Процедура КаталогУстановкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещениеЗавершение = Новый ОписаниеОповещения("КаталогНастройкиТЖЗавершениеВыбора", ЭтотОбъект);
	ОбщийКлиент.ВыбратьКаталог(Объект.КаталогНастройкиТЖ, ОписаниеОповещениеЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогНастройкиТЖЗавершениеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		Объект.КаталогНастройкиТЖ = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЛоговНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещениеЗавершение = Новый ОписаниеОповещения("КаталогЛоговЗавершениеВыбора", ЭтотОбъект);
	ОбщийКлиент.ВыбратьКаталог(Объект.КаталогЛогов, ОписаниеОповещениеЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЛоговЗавершениеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		Объект.КаталогЛогов = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЛоговСетевойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	ОписаниеОповещениеЗавершение = Новый ОписаниеОповещения("КаталогЛоговСетевойЗавершениеВыбора", ЭтотОбъект);
	ОбщийКлиент.ВыбратьКаталог(Объект.КаталогЛоговСетевой, ОписаниеОповещениеЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЛоговСетевойЗавершениеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		Объект.КаталогЛоговСетевой = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныТЖНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	Если ЭтотОбъект.ВерсияПлатформы > 8000300000000000 Тогда
		Если Объект.ПроизвольныйТекстНастройки Тогда
			ПеретаскиваемыйШаблон = ЭтотОбъект.ШаблоныТЖ[ПараметрыПеретаскивания.Значение[0]].Шаблон; 
			ПараметрыПеретаскивания.Значение = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныТЖОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ЭтотОбъект.ВерсияПлатформы > 8000300000000000 Тогда
		Если Объект.ПроизвольныйТекстНастройки Тогда
			Если ЗначениеЗаполнено(ЭтотОбъект.НастройкаФорматированныйДокумент.ПолучитьТекст()) Тогда
				ЭтотОбъект.НастройкаФорматированныйДокумент.Элементы.Добавить();
			КонецЕсли;
			
			ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.НастройкаФорматированныйДокумент, ПеретаскиваемыйШаблон);
			ПеретаскиваемыйШаблон = "";
		Иначе
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныТЖПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ШаблоныТЖПриАктивизацииСтрокиЧерезОбработчик", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныТЖПриАктивизацииСтрокиЧерезОбработчик()
	ЭтотОбъект.ШаблонФорматированныйДокумент.Удалить();
	Если ЭтотОбъект.ВерсияПлатформы > 8000300000000000 Тогда
		ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.ШаблонФорматированныйДокумент, ЭтотОбъект.Элементы.ШаблоныТЖ.ТекущиеДанные.Шаблон);
	Иначе
		ЭтотОбъект.ШаблонТекст = ЭтотОбъект.Элементы.ШаблоныТЖ.ТекущиеДанные.Шаблон;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНовыйНастройкиТехЖурнала()
	config = "</config>";
	
	Если ЭтотОбъект.ОшибкаЧтения Тогда
		ТекстНастройкиБыл = "";
		Префикс = "";
	Иначе
		ТекстНастройкиБыл = ЭтотОбъект.ТекущийНастройкиТехЖурналаСтрока;
		ДокументDom = ОбщийКлиентСервер.ПолучитьDOMИзСтрокиXML(ТекстНастройкиБыл);
		Префикс = ДокументDom.ЭлементДокумента.Префикс;
		
		Если ЗначениеЗаполнено(Префикс) Тогда
			config = "</" + Префикс + ":config>";
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстНастройкиБыл) Тогда
		УИД_ТЖ = "<!--Настройки ЦКК: " + ЭтотОбъект.СсылкаОбъекта.УникальныйИдентификатор();
		ИндексУИД = СтрНайти(ТекстНастройкиБыл, УИД_ТЖ);
		Если ИндексУИД > 0 Тогда
			ТекстНастройки = Лев(ТекстНастройкиБыл, ИндексУИД - 1);
			ТекстНастройкиБыл = Сред(ТекстНастройкиБыл, ИндексУИД + СтрДлина(УИД_ТЖ));
			
			ИндексУИД = СтрНайти(ТекстНастройкиБыл, УИД_ТЖ);
			Если ИндексУИД > 0 Тогда
				ТекстНастройки = ТекстНастройки + Сред(ТекстНастройкиБыл, ИндексУИД + СтрДлина(УИД_ТЖ + "-->"));
			КонецЕсли;
		Иначе
			ТекстНастройки = ТекстНастройкиБыл;
		КонецЕсли;
	Иначе
		УИД_ТЖ = "<!--Настройки ЦКК: " + ЭтотОбъект.СсылкаОбъекта.УникальныйИдентификатор();
		
		ТекстНастройки = 
		"<?xml version=""1.0""?>" + Символы.ПС +
		"<config xmlns=""http://v8.1c.ru/v8/tech-log"">" + Символы.ПС + Символы.ПС;
	КонецЕсли;
	
	ТекстНастройки = СтрЗаменить(ТекстНастройки, config, Символы.ПС);
		
	ТекстНастройкиТело = СтрЗаменить(СформироватьТекстНастройки(Префикс), "[Каталог логов]", Объект.КаталогЛогов);
	
	ТекстНастройки =
	ТекстНастройки + 
	УИД_ТЖ + "; шаблон ТЖ " + Объект.РабочийСервер + "; " + ЭтотОбъект.ТекущийПользователь + "; " + ТекущаяДата() + "-->" + Символы.ПС +
	ТекстНастройкиТело + Символы.ПС + 
	УИД_ТЖ + "-->" + Символы.ПС +
	config;
	
	СимволыПС3 = Символы.ПС + Символы.ПС + Символы.ПС;
	СимволыПС2 = Символы.ПС + Символы.ПС;
	ИндексТройнойПеренос = 1;
	Пока ИндексТройнойПеренос > 0 Цикл
		ТекстНастройки = СтрЗаменить(ТекстНастройки, СимволыПС3, СимволыПС2);
		ИндексТройнойПеренос = СтрНайти(ТекстНастройки, СимволыПС3);
	КонецЦикла;
	
	ЭтотОбъект.НовыйНастройкиТехЖурналаФорматированныйДокумент.Удалить();
	ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.НовыйНастройкиТехЖурналаФорматированныйДокумент, ТекстНастройки);
КонецПроцедуры

&НаКлиенте
Процедура СтраницыОсновнаяПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница.Имя = "СтраницаТекущийLogCfg" Тогда
		ПодключитьОбработчикОжидания("ОткрытьСтраницаТекущийLogCfg", 0.1, Истина);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтраницаТекущийLogCfg()
	Если НЕ ЭтотОбъект.ЕстьЧтение Тогда
		ЭтотОбъект.ЕстьЧтение = Истина;
		ЭтотОбъект.ТекущийНастройкиТехЖурналаФорматированныйДокумент.Удалить();
		ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.ТекущийНастройкиТехЖурналаФорматированныйДокумент, "Получение данных...");
		
		ПодключитьОбработчикОжидания("ПрочитатьТекущийФайлНастроек", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьТекущийФайлНастроек()
	Результат = ПолучитьТекущийФайлНастроек(Объект.КаталогНастройкиТЖ, Объект.Отключен);
	ЭтотОбъект.ОшибкаЧтения = Результат.ОшибкаЧтения;
	
	ЭтотОбъект.ТекущийНастройкиТехЖурналаСтрока = Результат.НастройкиТекст;
	ЭтотОбъект.ТекущийНастройкиТехЖурналаФорматированныйДокумент.Удалить();
	ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.ТекущийНастройкиТехЖурналаФорматированныйДокумент, ЭтотОбъект.ТекущийНастройкиТехЖурналаСтрока);
	
	ПоказатьНовыйНастройкиТехЖурнала();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьСекцияDUMP(КаталогНастроек, Отключен, Ссылка)
	Если Прав(КаталогНастроек, 1) = "\" Тогда
		КаталогНастроекБуфер = КаталогНастроек;
	Иначе
		КаталогНастроекБуфер = КаталогНастроек + "\";
	КонецЕсли;
	
	Если Отключен Тогда
		ИмяФайла = "logcfg_off.xml";
	Иначе
		ИмяФайла = "logcfg.xml";
	КонецЕсли;
	
	ФайлНастроек = Новый Файл(КаталогНастроекБуфер + ИмяФайла);
	Если ФайлНастроек.Существует() Тогда
		ЧтениеТекста = Новый ЧтениеТекста(ФайлНастроек.ПолноеИмя);
		Настройки = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		Индекс = СтрНайти(Настройки, "<dump");
		Если Индекс > 0 Тогда
			УИД_ТЖ = Справочники.ТехнологическиеЖурналы.ПолучитьУИД_ТЖ(Ссылка);
			Настройки = Справочники.ТехнологическиеЖурналы.УдалитьСвоиСекции(Настройки, УИД_ТЖ);
			Индекс = СтрНайти(Настройки, "<dump");
			Если Индекс > 0 Тогда
				Возврат Истина;
			Иначе
				Возврат ЛожЬ;
			КонецЕсли;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ПолучитьТекстФорматированногоДокумента(ФорматированныйДокумент)
	Текст = "";
	Для Каждого ТекПараграф Из ФорматированныйДокумент.Элементы Цикл
		Отступ = ТекПараграф.Отступ;
		Пока Отступ > 0 Цикл
			Текст = Текст + Символы.Таб;
			Отступ = Отступ - 20;
		КонецЦикла;
		
		Для Каждого ТекЭлемент Из ТекПараграф.Элементы Цикл
			Если ТипЗнч(ТекЭлемент) = Тип("ТекстФорматированногоДокумента") Тогда
				Текст = Текст + ТекЭлемент.Текст;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(Текст) Тогда
			Текст = Текст + Символы.ПС;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Текст;
КонецФункции

&НаКлиенте
Функция СформироватьТекстНастройки(Префикс)
	Если ЭтотОбъект.ВерсияПлатформы > 8000300000000000 Тогда
		Если Объект.ПроизвольныйТекстНастройки Тогда
			ТекстШаблона = "";
			Объект.ШаблоныТЖ.Очистить();
			ТекстШаблона = ПолучитьТекстФорматированногоДокумента(ЭтотОбъект.НастройкаФорматированныйДокумент);
		Иначе
			ТекстШаблона = "";
			Для Каждого ТекШаблон Из Объект.ШаблоныТЖ Цикл
				Если ЗначениеЗаполнено(Префикс) Тогда
					ТекТекстШаблона = СтрЗаменить(ТекШаблон.ТекстШаблона, "</", "☺");
					
					ТекТекстШаблона = СтрЗаменить(ТекТекстШаблона, "<", "<" + Префикс +":");
					ТекТекстШаблона = СтрЗаменить(ТекТекстШаблона, "☺", "</" + Префикс + ":");
				Иначе
					ТекТекстШаблона = ТекШаблон.ТекстШаблона;
				КонецЕсли;
				
				ТекстШаблона = ТекстШаблона + ТекТекстШаблона + Символы.ПС + Символы.ПС;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекстШаблона;
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.Настройка = СформироватьТекстНастройки("");
			
	Если ЭтотОбъект.Элементы.СтраницыОсновная.ТекущаяСтраница = ЭтотОбъект.Элементы.СтраницаТекущийLogCfg Тогда
		ПрямаяЗаписьДанные = ПолучитьТекстФорматированногоДокумента(ЭтотОбъект.НовыйНастройкиТехЖурналаФорматированныйДокумент);
		ПараметрыЗаписи.Вставить("ПрямаяЗапись", Истина);
		ПараметрыЗаписи.Вставить("ПрямаяЗаписьДанные", ПрямаяЗаписьДанные);
		
		Возврат;
	КонецЕсли;
		
	Если СтрНайти(Объект.Настройка, "<dump") > 0 И ЕстьСекцияDUMP(Объект.КаталогНастройкиТЖ, Объект.Отключен, ЭтотОбъект.СсылкаОбъекта) Тогда
		Если ПередЗаписьюВопрос <> Истина Тогда
			Отказ = Истина;
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект, ПараметрыЗаписи);
			ПоказатьВопрос(ОписаниеОповещения, "В настройках технологического журнала найдена секция DUMP!" + Символы.ПС + "Перезаписать секцию?", РежимДиалогаВопрос.ДаНетОтмена, 60);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПередЗаписьюВопрос = Истина;
		ДополнительныеПараметры.Вставить("DUMP", "Перезаписать");
		Записать(ДополнительныеПараметры);
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		ПередЗаписьюВопрос = Истина;
		ДополнительныеПараметры.Вставить("DUMP", "Оставить");
		Записать(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеЦККПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		Элемент.ТекущиеДанные.ПередаватьДанные = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПутьККонфигурационномуФайлу()
	КаталогКонфигурацииПриложения = Общий.ПутьККонфигурационномуФайлу();	
	
	Возврат КаталогКонфигурацииПриложения;
КонецФункции

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ТекущийОбъект.Ссылка = Справочники.ТехнологическиеЖурналы.ПустаяСсылка() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(ЭтотОбъект.СсылкаОбъекта);
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("DUMP") Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("DUMP", ПараметрыЗаписи.DUMP);
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("ПрямаяЗапись") Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПрямаяЗапись", ПараметрыЗаписи.ПрямаяЗапись);
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("ПрямаяЗаписьДанные") Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПрямаяЗаписьДанные", ПараметрыЗаписи.ПрямаяЗаписьДанные);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьТекущийНастройкиТехЖурнала(Команда)
	ЭтотОбъект.ТекущийНастройкиТехЖурналаСтрока = "Получение данных...";
	ЭтотОбъект.ТекущийНастройкиТехЖурналаФорматированныйДокумент.Удалить();
	ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.ТекущийНастройкиТехЖурналаФорматированныйДокумент, ЭтотОбъект.ТекущийНастройкиТехЖурналаСтрока, ЭтотОбъект.ВерсияПлатформы);
		
	ПодключитьОбработчикОжидания("ПрочитатьТекущийНастройкиТехЖурналаЧерезОжидание", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьТекущийНастройкиТехЖурналаЧерезОжидание()
	Результат = ПолучитьТекущийФайлНастроек(Объект.КаталогНастройкиТЖ, Объект.Отключен);
	ЭтотОбъект.ОшибкаЧтения = Результат.ОшибкаЧтения;
	
	НастройкиТекст = Результат.НастройкиТекст;
	
	Если НастройкиТекст <> Неопределено Тогда
		ЭтотОбъект.ТекущийНастройкиТехЖурналаСтрока = НастройкиТекст;
		ЭтотОбъект.ТекущийНастройкиТехЖурналаФорматированныйДокумент.Удалить();
		ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.ТекущийНастройкиТехЖурналаФорматированныйДокумент, ЭтотОбъект.ТекущийНастройкиТехЖурналаСтрока, ЭтотОбъект.ВерсияПлатформы);
	КонецЕсли;
	
	ЭтотОбъект.Элементы.ТекущийНастройкиТехЖурналаСтрока.ОбновитьТекстРедактирования();
КонецПроцедуры

&НаКлиенте
Процедура ПроизвольныйТекстНастройкиПриИзменении(Элемент)
	Если Объект.ПроизвольныйТекстНастройки Тогда
		ТекстНастройки = СформироватьТекстНастройки("");
		ЭтотОбъект.НастройкаФорматированныйДокумент.Удалить();
		ОбщийКлиентСервер.ФорматированныйДокументПодсветкаXML(ЭтотОбъект.НастройкаФорматированныйДокумент, ТекстНастройки, ЭтотОбъект.ВерсияПлатформы);
		
		ВидимостьФорматированныйДокументКлиент(Истина);
		ВидимостьВыбранныеШаблоныКлиент(Ложь);
	Иначе
		ВидимостьФорматированныйДокументКлиент(Ложь);
		ВидимостьВыбранныеШаблоныКлиент(Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныТЖВыбранныеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Для Каждого ТекДанные Из ПараметрыПеретаскивания.Значение Цикл
		НовСтрока = Объект.ШаблоныТЖ.Добавить();
		НовСтрока.ШаблонТЖВыбранный = ТекДанные.Ссылка;
		НовСтрока.ТекстШаблона = ТекДанные.Шаблон;
	КонецЦикла;
	
	Модифицированность = Истина;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ТехнологическийЖурналШаблонЗаписан" Тогда
		ЭтотОбъект.Прочитать();
		
		Для Каждого ТекДанные Из ЭтотОбъект.ШаблоныТЖ Цикл
			Если ТекДанные.Ссылка = Параметр.Ссылка Тогда
				ТекДанные.Шаблон = Параметр.Шаблон;
			КонецЕсли;
		КонецЦикла;
		ПодключитьОбработчикОжидания("ШаблоныТЖПриАктивизацииСтрокиЧерезОбработчик", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ШаблоныТЖВыбранныеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры


&НаКлиенте
Процедура ВидимостьНовый(Команда)
	ЭтотОбъект.Элементы.НастройкиТехЖурналаНовый.Видимость = НЕ ЭтотОбъект.Элементы.НастройкиТехЖурналаНовый.Видимость;
	ЭтотОбъект.Элементы.ГруппаКаталогЛогов.Видимость = НЕ ЭтотОбъект.Элементы.ГруппаКаталогЛогов.Видимость;
	
	Если ЭтотОбъект.Элементы.НастройкиТехЖурналаНовый.Видимость Тогда
		ЭтотОбъект.Элементы.ВидимостьНовый.Картинка = БиблиотекаКартинок.ПереместитьВлево;
	Иначе
		ЭтотОбъект.Элементы.ВидимостьНовый.Картинка = БиблиотекаКартинок.ПереместитьВправо;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ТекущийНастройкиТехЖурналаФорматированныйДокументПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры


&НаКлиенте
Процедура НастройкаФорматированныйДокументПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры


&НаКлиенте
Процедура ВидимостьНаДиске(Команда)
	ЭтотОбъект.Элементы.НастройкиТехЖурналаДиск.Видимость = НЕ ЭтотОбъект.Элементы.НастройкиТехЖурналаДиск.Видимость;
	
	Если ЭтотОбъект.Элементы.НастройкиТехЖурналаДиск.Видимость Тогда
		ЭтотОбъект.Элементы.ВидимостьНаДиске.Картинка = БиблиотекаКартинок.ПереместитьВправо;
	Иначе
		ЭтотОбъект.Элементы.ВидимостьНаДиске.Картинка = БиблиотекаКартинок.ПереместитьВлево;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПрочитатьТекущийНастройкиТехЖурнала(ЭтотОбъект.Команды.ПрочитатьТекущийНастройкиТехЖурнала);
	Если ПараметрыЗаписи.Свойство("Закрыть") И ПараметрыЗаписи.Закрыть Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура НовыйСформироватьИзШаблона(Команда)
	ПоказатьНовыйНастройкиТехЖурнала();
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ПараметрыЗаписи = Новый Структура("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
КонецПроцедуры

