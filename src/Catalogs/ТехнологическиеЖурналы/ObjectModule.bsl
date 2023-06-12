#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ПрямаяЗапись") Тогда
		ПрямаяЗапись = ЭтотОбъект.ДополнительныеСвойства.ПрямаяЗапись;
	Иначе
		ПрямаяЗапись = Ложь;
	КонецЕсли;
	
	Если ПрямаяЗапись Тогда
		ПрямаяЗапись(ЭтотОбъект.ДополнительныеСвойства.ПрямаяЗаписьДанные);
	Иначе
		СформироватьИЗаписать();
	КонецЕсли;
КонецПроцедуры

Процедура ПрямаяЗапись(ТекстНастройки)
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ЗаписатьФайлНастроек") Тогда
		ЗаписатьФайлНастроек = ЭтотОбъект.ДополнительныеСвойства.ЗаписатьФайлНастроек;
	Иначе
		ЗаписатьФайлНастроек = Истина;
	КонецЕсли;

	Если ЗаписатьФайлНастроек Тогда
		КаталогНастроек = ЭтотОбъект.КаталогНастройкиТЖ;
		Если Прав(КаталогНастроек, 1) <> "\" Тогда
			КаталогНастроек = КаталогНастроек + "\";
		КонецЕсли;
		
		ТекстНастройки = ОбщийКлиентСервер.ПолучитьСтрокуXMLИзDOM(ОбщийКлиентСервер.ПолучитьDOMИзСтрокиXML(ТекстНастройки, Ложь));
		
		Если ЭтотОбъект.Отключен Тогда
			УИД_ТЖ = Справочники.ТехнологическиеЖурналы.ПолучитьУИД_ТЖ(ЭтотОбъект.Ссылка);
			ТекстНастройки = Справочники.ТехнологическиеЖурналы.УдалитьСвоиСекции(ТекстНастройки, УИД_ТЖ);
		КонецЕсли;
				
		Файл = Новый Файл(КаталогНастроек);
		Если Файл.Существует() Тогда
			ЗаписьТекста = Новый ЗаписьТекста(КаталогНастроек + "logcfg.xml");
			ЗаписьТекста.Записать(ТекстНастройки);
			ЗаписьТекста.Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура СформироватьИЗаписать()
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ЗаписатьФайлНастроек") Тогда
		ЗаписатьФайлНастроек = ЭтотОбъект.ДополнительныеСвойства.ЗаписатьФайлНастроек;
	Иначе
		ЗаписатьФайлНастроек = Истина;
	КонецЕсли;
	
	Если ЗаписатьФайлНастроек Тогда
		УИД_ТЖ = Справочники.ТехнологическиеЖурналы.ПолучитьУИД_ТЖ(ЭтотОбъект.Ссылка);
		ТекстНастройки = "";
		
		Если ЭтотОбъект.ДополнительныеСвойства.Свойство("DUMP") Тогда
			СекцияDUMP = ЭтотОбъект.ДополнительныеСвойства.DUMP;
		Иначе
			СекцияDUMP = "НичегоНеДелать";
		КонецЕсли;
		
		КаталогНастроек = ЭтотОбъект.КаталогНастройкиТЖ;
		Если Прав(КаталогНастроек, 1) <> "\" Тогда
			КаталогНастроек = КаталогНастроек + "\";
		КонецЕсли;
		
		
		ФайлНастроек = Новый Файл(КаталогНастроек + "logcfg.xml");
		
		ЕстьNS = Ложь;
		config = "</config>";
		Если ФайлНастроек.Существует() Тогда
			ЧтениеТекста = Новый ЧтениеТекста(ФайлНастроек.ПолноеИмя);
			ТекстНастройкиБыл = ЧтениеТекста.Прочитать();
			ЧтениеТекста.Закрыть();
			
			Попытка
				ДокументDom = ОбщийКлиентСервер.ПолучитьDOMИзСтрокиXML(ТекстНастройкиБыл);
				Префикс = ДокументDom.ЭлементДокумента.Префикс;
				
				Если ЗначениеЗаполнено(Префикс) Тогда
					config = "</" + Префикс + ":config>";
				КонецЕсли;
				
				ТекстНастройки = Справочники.ТехнологическиеЖурналы.УдалитьСвоиСекции(ТекстНастройкиБыл, УИД_ТЖ);
				Если СекцияDUMP = "Перезаписать" Тогда
					ТекстНастройки = Справочники.ТехнологическиеЖурналы.УдалитьСекциюDUMP(ТекстНастройки);
				КонецЕсли;
			Исключение
				ТекстНастройки = 
				"<?xml version=""1.0""?>" + Символы.ПС +
				"<config xmlns=""http://v8.1c.ru/v8/tech-log"">" + Символы.ПС + Символы.ПС;
				
				Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЗаписьЖурналаРегистрации("Ошибка записи файла " + ФайлНастроек.ПолноеИмя, УровеньЖурналаРегистрации.Ошибка,,,Комментарий);
			КонецПопытки;
		Иначе
			ТекстНастройки = 
			"<?xml version=""1.0""?>" + Символы.ПС +
			"<config xmlns=""http://v8.1c.ru/v8/tech-log"">" + Символы.ПС + Символы.ПС;
		КонецЕсли;
		ТекстНастройки = СтрЗаменить(ТекстНастройки, config, Символы.ПС);
		
		Если НЕ ЭтотОбъект.Отключен Тогда
			//Если обнаружена секция DUMP, созданная не ЦКК
			//и пользователь выбрал оставить стороннюю секцию,
			//то удаляю секцию DUMP ЦКК
			Если СекцияDUMP = "Оставить" Тогда
				ЭтотОбъект.Настройка = Справочники.ТехнологическиеЖурналы.УдалитьСекциюDUMP(ЭтотОбъект.Настройка);
			КонецЕсли;
			ТекстНастройкиТело = СтрЗаменить(ЭтотОбъект.Настройка, "[Каталог логов]", ЭтотОбъект.КаталогЛогов);
			Если ЗначениеЗаполнено(Префикс) Тогда
				ТекстНастройкиТело = СтрЗаменить(ТекстНастройкиТело, "</", "☺");
				
				ТекстНастройкиТело = СтрЗаменить(ТекстНастройкиТело, "<", "<" + Префикс + ":");
				ТекстНастройкиТело = СтрЗаменить(ТекстНастройкиТело, "☺", "</" + Префикс + ":");
			КонецЕсли;
			
			ТекстНастройки =
			ТекстНастройки + 
			УИД_ТЖ + "; шаблон ТЖ " + ЭтотОбъект.РабочийСервер + "; " + ПользователиИнформационнойБазы.ТекущийПользователь() + "; " + ТекущаяДата() + "-->" + Символы.ПС +
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
		Иначе
			ТекстНастройки =
			ТекстНастройки + 
			config;
		КонецЕсли;
		
		Файл = Новый Файл(КаталогНастроек);
		Если Файл.Существует() Тогда
			ЗаписьТекста = Новый ЗаписьТекста(КаталогНастроек + "logcfg.xml");
			ЗаписьТекста.Записать(ТекстНастройки);
			ЗаписьТекста.Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ИзменитьШаблон(ШаблонСсылка) Экспорт
	ТекстШаблона = "";
	Для Каждого ТекШаблон Из ШаблоныТЖ Цикл
		Если ТекШаблон.ШаблонТЖВыбранный = ШаблонСсылка Тогда
			ТекШаблон.ТекстШаблона = ШаблонСсылка.Шаблон;
		КонецЕсли;
		
		ТекстШаблона = ТекстШаблона + ТекШаблон.ТекстШаблона + Символы.ПС + Символы.ПС;
	КонецЦикла;
	ЭтотОбъект.Настройка = ТекстШаблона;
	Записать();
КонецПроцедуры

Процедура УдалитьШаблон(ШаблонСсылка) Экспорт
	ПараметрыОтбора = Новый Структура("ШаблонТЖВыбранный", ШаблонСсылка);
	СтрокиНашел = ШаблоныТЖ.НайтиСтроки(ПараметрыОтбора);
	Для Каждого ТекСтрока Из СтрокиНашел Цикл
		ШаблоныТЖ.Удалить(ТекСтрока);
	КонецЦикла;
	
	ТекстШаблона = "";
	Для Каждого ТекШаблон Из ШаблоныТЖ Цикл
		ТекстШаблона = ТекстШаблона + ТекШаблон.ТекстШаблона + Символы.ПС + Символы.ПС;
	КонецЦикла;
	ЭтотОбъект.Настройка = ТекстШаблона;
	
	Записать();
КонецПроцедуры

#КонецЕсли