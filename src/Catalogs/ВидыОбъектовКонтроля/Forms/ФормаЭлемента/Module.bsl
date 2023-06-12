
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Общий.ЭтоНовыйОбъект(Объект) Тогда 
		Отказ = Истина;		
	Иначе		
		ЗаполнитьЗначенияСпециальныхНастроек();
		ЗаполнитьФормуКонтрольныхПроцедур();
	
	КонецЕсли;
	ОбновитьРекомендации();
    
    Если Объект.Ссылка = Справочники.ВидыОбъектовКонтроля.ИнформационнаяБаза Тогда
        ЭлементКаталогЖурналаРегистрации = ЭтотОбъект.Элементы.Найти("КаталогЖурналРегистрации");
        Если ЭлементКаталогЖурналаРегистрации <> Неопределено Тогда
            ЭлементКаталогЖурналаРегистрации.Видимость = Ложь;
        КонецЕсли;
    КонецЕсли;
        
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	НастройкиСервер.РазобратьИСохранитьДинамическиеНастройки(ТекущийОбъект.Ссылка, ЭтотОбъект, "НастройкиПоУмолчаниюДляВидаОбъектаКонтроля");	
	ОбновитьКонтрольныеПроцедуры(ТекущийОбъект.Ссылка);		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Изменение.Справочник.ВидыОбъектовКонтроля", Объект.Ссылка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьФормуКонтрольныхПроцедур()
	КонтрольныеПроцедурыДанные = РеквизитФормыВЗначение("КонтрольныеПроцедуры");
	
	НастройкиСервер.ЗаполнитьФормуКонтрольныхПроцедур(Объект.Ссылка, Объект.Ссылка, КонтрольныеПроцедурыДанные);
	
	ЗначениеВРеквизитФормы(КонтрольныеПроцедурыДанные, "КонтрольныеПроцедуры");	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьЗначенияСпециальныхНастроек()
	НастройкиСервер.ЗаполнитьПоляДинамическихНастроекНаФорме(Объект.Ссылка, ЭтотОбъект, "НастройкиПоУмолчаниюДляВидаОбъектаКонтроля");		 
КонецПроцедуры

&НаСервере
Процедура ОбновитьКонтрольныеПроцедуры(ТекущийОбъектСсылка)
	КонтрольныеПроцедурыДанные = РеквизитФормыВЗначение("КонтрольныеПроцедуры");
	Для Каждого СтрокаДанных Из КонтрольныеПроцедурыДанные Цикл
    	Если НЕ СтрокаДанных.ОтветственныйЗаНастройку.Пустая() Тогда
			УправлениеЗадачами.НазначитьОтветственногоЗаНастройкуПроцедуры(
				ТекущийОбъектСсылка.Ссылка,
				СтрокаДанных.ВидКонтрольнойПроцедуры,
				СтрокаДанных.ОтветственныйЗаНастройку
			);
		КонецЕсли;
	КонецЦикла;
	ЗначениеВРеквизитФормы(КонтрольныеПроцедурыДанные, "КонтрольныеПроцедуры");
КонецПроцедуры	
 
&НаСервере
Процедура ОбновитьРекомендации()
	ИмяМакета = НазваниеСтраницыСправки();
	Если ИмяМакета <> Неопределено Тогда
		Справка = Общий.ТекстHTMLМакета(НазваниеСтраницыСправки()); 	
	Иначе
		Элементы.Рекомендации.Видимость = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры	

&НаСервере
Функция НазваниеСтраницыСправки()
	
	Возврат РасширяемыеПараметрыЯдра.СписокМакетовРекомендацийВидыОбъектов().Получить(Объект.Ссылка);
	
КонецФункции





