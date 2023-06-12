#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПрограммныйИнтерфейс

Функция ТипИнцидента(ТипИнцидентаПредставление, УровеньИнцидента) Экспорт
    
    ХешТипа = Справочники.ТипыИнцидентов.ХешТипИнцидента(ТипИнцидентаПредставление);
    Возврат СоздатьЭлементПоХешу(ХешТипа, ТипИнцидентаПредставление, УровеньИнцидента);
    
КонецФункции

Функция СсылкаПоНаименованию(Наименование) Экспорт
	Возврат Справочники.ТипыИнцидентов.НайтиПоНаименованию(Наименование);
КонецФункции

Функция СсылкаПоХешу(ХешТипа) Экспорт
	Возврат Справочники.ТипыИнцидентов.НайтиПоРеквизиту("ХешТипа", ХешТипа);
КонецФункции

Функция СоздатьЭлементПоНаименованию(Наименование, ПараметрыСоздания = Неопределено) Экспорт
	
	Ссылка = СсылкаПоНаименованию(Наименование);
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Попытка
			НачатьТранзакцию();
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ТипыИнцидентов");
			ЭлементБлокировки.УстановитьЗначение("Наименование", Наименование);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Ссылка = СсылкаПоНаименованию(Наименование);
			
            Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
                
                Ответственный = Неопределено;
                УровеньИнцидента = Неопределено;
                ОбъектЦКК = Неопределено;
                Подсистема = Неопределено;
                
                Если ПараметрыСоздания = Неопределено Тогда
                    ПараметрыСоздания = Новый Структура("УровеньИнцидента", Перечисления.УровниИнцидентов.Предупреждение);
                КонецЕсли;
                                
                ПараметрыСоздания.Свойство("Ответственный", Ответственный);
                ПараметрыСоздания.Свойство("УровеньИнцидента", УровеньИнцидента);
                ПараметрыСоздания.Свойство("ОбъектЦКК", ОбъектЦКК);
                ПараметрыСоздания.Свойство("Подсистема", Подсистема);
                
				ТипИнцидента = Справочники.ТипыИнцидентов.СоздатьЭлемент();
				ТипИнцидента.Наименование = Наименование;
                ТипИнцидента.Подсистема = Подсистема;
				ТипИнцидента.Ответственный = Ответственный;
				ТипИнцидента.УровеньИнцидента = УровеньИнцидента;
				ТипИнцидента.ОбъектЦКК = ОбъектЦКК;
				ТипИнцидента.Записать();
				
				Ссылка = ТипИнцидента.Ссылка;
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
	Возврат Ссылка;
	
КонецФункции

Функция ПараметрыСозданияПоУмолчанию(Ответсвенный, УровеньИнцидента, ОбъектЦКК) Экспорт
    
    Возврат Новый Структура("Ответсвенный, УровеньИнцидента, ОбъектЦКК", Ответсвенный, УровеньИнцидента, ОбъектЦКК);
    
КонецФункции

Функция СоздатьЭлементПоХешу(ХешТипа, Наименование, УровеньИнцидента) Экспорт
    
    Ссылка = СсылкаПоХешу(ХешТипа);
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Попытка
			НачатьТранзакцию();
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ТипыИнцидентов");
			ЭлементБлокировки.УстановитьЗначение("ХешТипа", ХешТипа);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Ссылка = СсылкаПоХешу(ХешТипа);
			
            Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
                
                Ответственный = Неопределено;
                ОбъектЦКК = Неопределено;
                Подсистема = Неопределено;
               
				ТипИнцидента = Справочники.ТипыИнцидентов.СоздатьЭлемент();
				ТипИнцидента.Наименование = Наименование;
                ТипИнцидента.Подсистема = Подсистема;
				ТипИнцидента.Ответственный = Ответственный;
				ТипИнцидента.УровеньИнцидента = УровеньИнцидента;
				ТипИнцидента.ОбъектЦКК = ОбъектЦКК;
                ТипИнцидента.ХешТипа = ХешТипа;
				ТипИнцидента.Записать();
				
				Ссылка = ТипИнцидента.Ссылка;
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
	Возврат Ссылка;
    
КонецФункции

Функция ХешТипИнцидента(Данные) Экспорт
    
    ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA256);
    ХешированиеДанных.Добавить(Данные);
    
    Возврат СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", "");
    
КонецФункции

#КонецОбласти

#КонецЕсли
