#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)
	Если ЗначениеЗаполнено(КонтурАдминистрирования) Тогда
		ВыполнитьОбновлениеНаСервере(Истина);
		Закрыть();
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Поле = "КонтурАдминистрирования";
		Сообщение.Текст = НСтр("ru='Не заполнен Контур администрирования'");
		Сообщение.Сообщить();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбновление(Команда)
	Если ЗначениеЗаполнено(КонтурАдминистрирования) Тогда
		ВыполнитьОбновлениеНаСервере(Ложь);
		Закрыть();
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Поле = "КонтурАдминистрирования";
		Сообщение.Текст =  НСтр("ru='Не заполнен Контур администрирования'");
		Сообщение.Сообщить();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбновлениеНаСервере(ТолькоПроверка)
	ТекДата = ТекущаяДатаСеанса();
	Для Каждого АгентОбновления Из СписокАгентов Цикл
		НачатьТранзакцию();
		
		Попытка
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗадачиОбновленияСценариевАдминистрирования");
			ЭлементБлокировки.УстановитьЗначение("Агент", АгентОбновления.Значение);
			ЭлементБлокировки.УстановитьЗначение("КонтурАдминистрирования", КонтурАдминистрирования);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать(); 
			
			СтатусыАктивнойКоманды = Новый СписокЗначений;
			СтатусыАктивнойКоманды.Добавить(Перечисления.СтатусыКоманд.Выполняется);
			СтатусыАктивнойКоманды.Добавить(Перечисления.СтатусыКоманд.Выполняется);
			
			
			Запрос = Новый Запрос("ВЫБРАТЬ
			                      |	ЗадачиОбновленияСценариевАдминистрирования.Агент КАК Агент
			                      |ИЗ
			                      |	РегистрСведений.ЗадачиОбновленияСценариевАдминистрирования КАК ЗадачиОбновленияСценариевАдминистрирования
			                      |ГДЕ
			                      |	ЗадачиОбновленияСценариевАдминистрирования.Агент = &Агент
			                      |	И ЗадачиОбновленияСценариевАдминистрирования.КонтурАдминистрирования = &КонтурАдминистрирования
			                      |	И (ЗадачиОбновленияСценариевАдминистрирования.СтатусКоманды = ЗНАЧЕНИЕ(Перечисление.СтатусыКоманд.Выполняется)
								  |		ИЛИ ЗадачиОбновленияСценариевАдминистрирования.СтатусКоманды = ЗНАЧЕНИЕ(Перечисление.СтатусыКоманд.Сформирована))");
			Запрос.УстановитьПараметр("Агент", АгентОбновления.Значение);
			Запрос.УстановитьПараметр("КонтурАдминистрирования", КонтурАдминистрирования);
			
			АктивныеЗадачи = Запрос.Выполнить();
			
			Если АктивныеЗадачи.Пустой() Тогда
				НЗ = РегистрыСведений.ЗадачиОбновленияСценариевАдминистрирования.СоздатьНаборЗаписей();
				НЗ.Отбор.Период.Установить(ТекДата);
				НЗ.Отбор.Агент.Установить(АгентОбновления.Значение);
				НЗ.Отбор.КонтурАдминистрирования.Установить(КонтурАдминистрирования);
				
				Запись = НЗ.Добавить();
				Запись.Период = ТекДата;
				Запись.Агент = АгентОбновления.Значение;
				Запись.КонтурАдминистрирования = КонтурАдминистрирования;
				Запись.ТолькоПроверка = ТолькоПроверка;
				Запись.СтатусКоманды = Перечисления.СтатусыКоманд.Сформирована;
				Запись.ДистрибутивWin = РасположениеДистрибутиваСкриптовWin;
				Запись.ДистрибутивLin = РасположениеДистрибутиваСкриптовLin;
				Запись.ДистрибутивPythonWin = РасположениеДистрибутиваPythonWin;
				Запись.ДистрибутивPythonLin = РасположениеДистрибутиваPythonLin;
				
				НЗ.Записать();
			Иначе
				Сообщение = Новый СообщениеПользователю;
				ТекстСообщения = "Для агента " + АгентОбновления.Значение + " контура " + КонтурАдминистрирования + " есть активные задания обновления";
				Сообщение.Текст = НСтр("ru='" + ТекстСообщения + "'");
				Сообщение.Сообщить();
			КонецЕсли;	
			
			Если Не РаботаСоСценариямиАвтоматизацииСервер.ЕстьАктивныеЭкземплярыСценариевДляАгента(АгентОбновления.Значение) Тогда
				Сообщение = Новый СообщениеПользователю;
				ТекстСообщения = "Для агента " + АгентОбновления.Значение + " найдены активные сценарии администрирования. Обновление запустится после их окончания";
				Сообщение.Текст = НСтр("ru='" + ТекстСообщения + "'");
				Сообщение.Сообщить();
			КонецЕсли;	
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(НСтр("ru='Обновление Агента'", Метаданные.ОсновнойЯзык.КодЯзыка), УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;	
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Агенты") Тогда
		СписокАгентов.ЗагрузитьЗначения(Параметры["Агенты"]);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура КонтурАдминистрированияПриИзмененииНаСервере()
	// Windows
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ЗадачиОбновленияСценариевАдминистрированияСрезПоследних.ДистрибутивWin КАК ДистрибутивWin,
	                      |	ЗадачиОбновленияСценариевАдминистрированияСрезПоследних.ДистрибутивPythonWin КАК ДистрибутивPythonWin
	                      |ИЗ
	                      |	РегистрСведений.ЗадачиОбновленияСценариевАдминистрирования.СрезПоследних(
	                      |			,
	                      |			КонтурАдминистрирования = &КонтурАдминистрирования
	                      |				И (ДистрибутивWin <> """"
	                      |				ИЛИ ДистрибутивPythonWin <> """")) КАК ЗадачиОбновленияСценариевАдминистрированияСрезПоследних");
	Запрос.УстановитьПараметр("Агенты", СписокАгентов);
	Запрос.УстановитьПараметр("КонтурАдминистрирования", КонтурАдминистрирования);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		РасположениеДистрибутиваСкриптовWin = Выборка.ДистрибутивWin;
		РасположениеДистрибутиваPythonWin = Выборка.ДистрибутивPythonWin;
	КонецЕсли;
	
	// Linux
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ЗадачиОбновленияСценариевАдминистрированияСрезПоследних.ДистрибутивLin КАК ДистрибутивLin,
	               |	ЗадачиОбновленияСценариевАдминистрированияСрезПоследних.ДистрибутивPythonLin КАК ДистрибутивPythonLin
	               |ИЗ
	               |	РегистрСведений.ЗадачиОбновленияСценариевАдминистрирования.СрезПоследних(
	               |			,
	               |			КонтурАдминистрирования = &КонтурАдминистрирования
	               |				И (ДистрибутивLin <> """"
	               |				ИЛИ ДистрибутивPythonLin <> """")) КАК ЗадачиОбновленияСценариевАдминистрированияСрезПоследних";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		РасположениеДистрибутиваСкриптовLin = Выборка.ДистрибутивLin;
		РасположениеДистрибутиваPythonLin = Выборка.ДистрибутивPythonLin;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура КонтурАдминистрированияПриИзменении(Элемент)
	Если Не РаботаСоСценариямиАвтоматизацииСервер.ПроверитьЗаполнениеПараметровКонтура(КонтурАдминистрирования) Тогда
		ПоказатьПредупреждение(, НСтр("ru='В контуре администрирования заполнены не все данные для запуска сценария. Необходимо заполнить'"));
		КонтурАдминистрирования = ПредопределенноеЗначение("Справочник.КонтурыАдминистрирования.ПустаяСсылка");
	Иначе
		КонтурАдминистрированияПриИзмененииНаСервере(); 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РасположениеДистрибутиваНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораКаталога(Элемент.Имя, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораКаталога(ИмяЭлемента, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.Заголовок = НСтр("ru='Выберите каталог дистрибутива'");
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияДиалогаВыбораКаталога", ЭтотОбъект, Новый Структура("ИмяЭлемента", ИмяЭлемента));	
	ДиалогВыбораФайла.Показать(Оповещение);
КонецПроцедуры	

&НаКлиенте
Процедура ПослеЗакрытияДиалогаВыбораКаталога(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		ЭтотОбъект[ДополнительныеПараметры.ИмяЭлемента] = ВыбранныеФайлы[0];
	КонецЕсли;	
КонецПроцедуры	

#КонецОбласти