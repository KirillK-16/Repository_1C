
Процедура ВыполнитьАнализ(КонтрольнаяПроцедура) Экспорт
    
    Настройки = РегистрыСведений.ПараметрыИнформационныхБаз.Получить(Новый Структура("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля));
			
	Если ЗначениеЗаполнено(Настройки.Кластер) Тогда
        
        НастройкиКластера = РегистрыСведений.ПараметрыКластеров.Получить(Новый Структура("ОбъектКонтроля", Настройки.Кластер));
        
        Настройки.Вставить("АдресКластера", НастройкиКластера.АдресКластера);
		Настройки.Вставить("ПортАгентаКластера", НастройкиКластера.ПортАгентаКластера);
		Настройки.Вставить("ПортКластера", НастройкиКластера.ПортКластера);
		Настройки.Вставить("АдминистраторКластера", НастройкиКластера.АдминистраторКластера);
		Настройки.Вставить("ПарольАдминистратораКластера", НастройкиКластера.ПарольАдминистратораКластера);
		Настройки.Вставить("ВерсияПлатформы", НастройкиКластера.ВерсияПлатформы);
		Настройки.Вставить("ИмяКластера", Настройки.АдресКластера + ":" + ОбщийКлиентСервер.ЧислоВСтроку(Настройки.ПортАгентаКластера));
		
		РабочиеСерверыКластера = Новый Массив;
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПараметрыРабочихСерверов.ОбъектКонтроля.Ссылка КАК РабочийСервер
		|ИЗ
		|	РегистрСведений.ПараметрыРабочихСерверов КАК ПараметрыРабочихСерверов
		|ГДЕ
		|	ПараметрыРабочихСерверов.Кластер = &Кластер";
		
		Запрос.УстановитьПараметр("Кластер", Настройки.Кластер);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			РабочийСервер = Выборка.РабочийСервер;
			Если ТипЗнч(РабочийСервер) = Тип("СправочникСсылка.ОбъектыКонтроля") Тогда
				РабочиеСерверыКластера.Добавить(РабочийСервер);
			КонецЕсли;
		КонецЦикла;
        
        Настройки.Вставить("РабочиеСерверыКластера", РабочиеСерверыКластера);
        
	КонецЕсли;
		
	НастройкиПриватныеСловарь = РегистрыСведений.НастройкиКонтрольНагрузочныхТестов.Получить(Новый Структура("КонтрольнаяПроцедура", КонтрольнаяПроцедура));
	
	Настройки.Вставить("КаталогВыгрузкиРезультатов", НастройкиПриватныеСловарь.КаталогВыгрузкиРезультатов);
	Настройки.Вставить("ДопустимоеОтклонениеПоПроизводительности", НастройкиПриватныеСловарь.ДопустимоеОтклонениеПоПроизводительности);
	Настройки.Вставить("ДопустимоеОтклонениеПоПотреблениюПамяти", НастройкиПриватныеСловарь.ДопустимоеОтклонениеПоПотреблениюПамяти);
	Настройки.Вставить("ЧислоПредыдущихЗапусков", НастройкиПриватныеСловарь.ЧислоПредыдущихЗапусков);
	Настройки.Вставить("УчитыватьТолькоУспешныеТесты", НастройкиПриватныеСловарь.УчитыватьТолькоУспешныеТесты);
	Настройки.Вставить("ПороговоеЧислоПользователей", НастройкиПриватныеСловарь.ПороговоеЧислоПользователей);
	Настройки.Вставить("УчитыватьПроизводительность", НастройкиПриватныеСловарь.УчитыватьПроизводительность);
	Настройки.Вставить("УчитыватьБлокировки", НастройкиПриватныеСловарь.УчитыватьБлокировки);
	Настройки.Вставить("УчитыватьДампы", НастройкиПриватныеСловарь.УчитыватьДампы);
	Настройки.Вставить("УчитыватьПотреблениеПамяти", НастройкиПриватныеСловарь.УчитыватьПотреблениеПамяти);
	Настройки.Вставить("УчитыватьИсключения", НастройкиПриватныеСловарь.УчитыватьИсключения);
    
    НетПроблем = Истина;
	
	Попытка
		ПараметрыСоединения = КонтрольПамятиСервер.ПроверитьСоединениеСКластером(
			Настройки.ИмяКластера,
			Настройки.ПортКластера, 
			Настройки.АдминистраторКластера, 
			Настройки.ПарольАдминистратораКластера,
			Настройки.ВерсияПлатформы
		);
	Исключение
		Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
					
		ЗаписьЖурналаРегистрации("КонтрольНагрузочныхТестов", УровеньЖурналаРегистрации.Ошибка, Метаданные.ОбщиеМодули.КонтрольНагрузочныхТестовСервер,,Комментарий);
		
		ИмяСтраницыСправки = "КонтрольПамятиНеизвестнаяОшибка";
		Сообщение = НСтр("ru = 'Кластер 1С недоступен.'");
		ВызватьИсключение;
		
	КонецПопытки;
	
	глМенеджерСоединений = ПараметрыСоединения["МенеджерСоединений"];
	глСоединениеСЦентральнымСервером = ПараметрыСоединения["СоединениеСЦентральнымСервером"];
	глКластер = ПараметрыСоединения["Кластер"];
	
	Сеансы = глСоединениеСЦентральнымСервером.GetSessions(глКластер);
	НомерСеанса = Сеансы.GetLowerBound();
	МаксимальныйИндекс = Сеансы.GetUpperBound();
	ЧислоСеансов = 0;
	Пока НомерСеанса <= МаксимальныйИндекс Цикл
		Снс = Сеансы.GetValue(НомерСеанса);
		Если Снс.InfoBase.Name = Настройки.ИмяБазы Тогда
			ЧислоСеансов = ЧислоСеансов + 1;
		КонецЕсли;
		НомерСеанса = НомерСеанса + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗапускиНагрузочногоТестирования.Ссылка
	|ИЗ
	|	Справочник.ЗапускиНагрузочногоТестирования КАК ЗапускиНагрузочногоТестирования
	|ГДЕ
	|	ЗапускиНагрузочногоТестирования.Владелец = &ИнформационнаяБаза
	|УПОРЯДОЧИТЬ ПО
	|	ЗапускиНагрузочногоТестирования.Дата УБЫВ";
	Запрос.УстановитьПараметр("ИнформационнаяБаза", КонтрольнаяПроцедура.ОбъектКонтроля);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Тест = Выборка.Ссылка;
	Иначе
		Тест = Новый Структура("ТестЗакончен", Истина);
	КонецЕсли;
	
	Если ЧислоСеансов >= Настройки.ПороговоеЧислоПользователей И Тест.ТестЗакончен Тогда
		ПометкаОЗапуске = Справочники.ЗапускиНагрузочногоТестирования.СоздатьЭлемент();
		ПометкаОЗапуске.ТестЗакончен = Ложь;
		ПометкаОЗапуске.Дата = ТекущаяДата();
		ПометкаОЗапуске.Владелец = КонтрольнаяПроцедура.ОбъектКонтроля;
		ПометкаОЗапуске.Записать();
		
		Если ТипЗнч(Тест) <> Тип("Структура") Тогда
			Отбор = Новый Структура("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля);
			ПараметрыИнформационнойБазы = РегистрыСведений.ПараметрыИнформационныхБаз.СоздатьМенеджерЗаписи();
			ПараметрыИнформационнойБазы.ОбъектКонтроля = КонтрольнаяПроцедура.ОбъектКонтроля;
			ПараметрыИнформационнойБазы.Прочитать();
			
			СообщениеПоЗадаче = "Был выполнен тест: с "
				+ Тест.Дата
				+ " до " + (Тест.Дата + Тест.ПродолжительностьВСекундах)
				+ ", максимальное число пользователей " + ЧислоСеансов
				+ ", кластер " + ПараметрыИнформационнойБазы.Кластер 
				+ ", ИБ " + КонтрольнаяПроцедура.ОбъектКонтроля;
		КонецЕсли;
	КонецЕсли;
	
	Если ЧислоСеансов < Настройки.ПороговоеЧислоПользователей И НЕ Тест.ТестЗакончен Тогда
		ИнформацияОЗапуске = Тест.ПолучитьОбъект();
		ВыполнитьКонтрольНагрузочногоТеста(КонтрольнаяПроцедура, Настройки, ИнформацияОЗапуске);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольНагрузочногоТеста(КонтрольнаяПроцедура, Настройки, ИнформацияОЗапуске)
    
    ТекущаяДата = ТекущаяДата();
    
    ИнформацияОЗапуске.ТестЗакончен = Истина;
    ИнформацияОЗапуске.ПродолжительностьВСекундах = ТекущаяДата - ИнформацияОЗапуске.Дата;
    
    НГраница = ИнформацияОЗапуске.Дата;
    ОбновлятьМожно = Истина;
    
    ДатыПредыдущихЗапусков = Новый Массив;
    ПредыдущиеТесты = Новый Структура(
    "ТаймаутовНаСУБД, ТаймаутовНа1С, ВзаимоблокировокНаСУБД, ВзаимоблокировокНа1С,
    |ТаймаутовНаСУБДМакс, ТаймаутовНа1СМакс, ВзаимоблокировокНаСУБДМакс, ВзаимоблокировокНа1СМакс, 
    |МаксимумПотребленияПамяти, ПотреблениеПамяти, ОбщееЧислоПадений",
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, Новый Массив, 0
    );
    
    ПредыдущиеТесты.Вставить("Дампы", Новый Соответствие);
    ПредыдущиеТесты.Вставить("ПоказателиПроизводительности", Новый Соответствие);
    ПредыдущиеТесты.Вставить("РейтингИсключенийПоЖурналу", Новый Соответствие);
    
    Запрос = Новый Запрос;
    ЗапросТекст = "ВЫБРАТЬ ПЕРВЫЕ %ЧислоПредыдущихЗапусков
    |	ЗапускиНагрузочногоТестирования.Ссылка
    |ИЗ
    |	Справочник.ЗапускиНагрузочногоТестирования КАК ЗапускиНагрузочногоТестирования
    |ГДЕ
    |	ЗапускиНагрузочногоТестирования.Владелец = &ИнформационнаяБаза
    |	И ЗапускиНагрузочногоТестирования.ТестЗакончен = Истина
    |	%УсловиеНаУспешностьТеста
    |УПОРЯДОЧИТЬ ПО
    |	ЗапускиНагрузочногоТестирования.Дата УБЫВ";
    ЗапросТекст = СтрЗаменить(ЗапросТекст, "%ЧислоПредыдущихЗапусков", Настройки.ЧислоПредыдущихЗапусков);
    Если Настройки.УчитыватьТолькоУспешныеТесты Тогда
        ЗапросТекст = СтрЗаменить(ЗапросТекст, "%УсловиеНаУспешностьТеста", " И ЗапускиНагрузочногоТестирования.ТестПройденУспешно = Истина ");
    Иначе
        ЗапросТекст = СтрЗаменить(ЗапросТекст, "%УсловиеНаУспешностьТеста", " ");
    КонецЕсли;
    Запрос.Текст = ЗапросТекст;
    Запрос.УстановитьПараметр("ИнформационнаяБаза", КонтрольнаяПроцедура.ОбъектКонтроля);
    Выборка = Запрос.Выполнить().Выбрать();
    
    РеальноеЧислоПредыдущихЗапусков = 0;
    Пока Выборка.Следующий() Цикл
        Запуск = Выборка.Ссылка;
        
        ДатаЗапуска = Запуск.Дата;
        ДатыПредыдущихЗапусков.Добавить(Новый Структура("ДатаНачала, ДатаОкончания", ДатаЗапуска, ДатаЗапуска + Запуск.ПродолжительностьВСекундах));
        
        ПредыдущиеТесты.ТаймаутовНаСУБД = ПредыдущиеТесты.ТаймаутовНаСУБД + Запуск.ТаймаутовНаСУБД;
        ПредыдущиеТесты.ТаймаутовНа1С = ПредыдущиеТесты.ТаймаутовНа1С + Запуск.ТаймаутовНа1С;
        ПредыдущиеТесты.ВзаимоблокировокНаСУБД = ПредыдущиеТесты.ВзаимоблокировокНаСУБД + Запуск.ВзаимоблокировокНаСУБД;
        ПредыдущиеТесты.ВзаимоблокировокНа1С = ПредыдущиеТесты.ВзаимоблокировокНа1С + Запуск.ВзаимоблокировокНа1С;
        
        ПредыдущиеТесты.ТаймаутовНаСУБДМакс = Макс(ПредыдущиеТесты.ТаймаутовНаСУБДМакс, Запуск.ТаймаутовНаСУБД);
        ПредыдущиеТесты.ТаймаутовНа1СМакс = Макс(ПредыдущиеТесты.ТаймаутовНа1СМакс, Запуск.ТаймаутовНа1С);
        ПредыдущиеТесты.ВзаимоблокировокНаСУБДМакс = Макс(ПредыдущиеТесты.ВзаимоблокировокНаСУБДМакс, Запуск.ВзаимоблокировокНаСУБД);
        ПредыдущиеТесты.ВзаимоблокировокНа1СМакс = Макс(ПредыдущиеТесты.ВзаимоблокировокНа1СМакс, Запуск.ВзаимоблокировокНа1С);
        
        ПредыдущиеТесты.МаксимумПотребленияПамяти = Макс(ПредыдущиеТесты.МаксимумПотребленияПамяти, Запуск.МаксимумПотребленияПамяти);
        
        ОбщееЧислоПадений = 0;
        Для Каждого СтрокаДампа Из Запуск.Дампы Цикл
            текДампы = ПредыдущиеТесты.Дампы;
            текЧисло = текДампы.Получить(СтрокаДампа.ВариантДампа);
            Если текЧисло = Неопределено Тогда
                текЧисло = 0;
            КонецЕсли;
            текЧисло = текЧисло + СтрокаДампа.Количество;
            текДампы.Вставить(СтрокаДампа.ВариантДампа, текЧисло);
            ОбщееЧислоПадений = ОбщееЧислоПадений + СтрокаДампа.Количество;
        КонецЦикла;
        ПредыдущиеТесты["ОбщееЧислоПадений"] = Макс(ОбщееЧислоПадений, ПредыдущиеТесты["ОбщееЧислоПадений"]);
        
        Для Каждого СтрокаПроизводительности Из Запуск.ПоказателиПроизводительности Цикл
            текПоказателиПроизводительности = ПредыдущиеТесты.ПоказателиПроизводительности;
            текДанные = текПоказателиПроизводительности.Получить(СтрокаПроизводительности.ИдентификаторКлючевойОперации);
            Если текДанные = Неопределено Тогда
                текДанные = Новый Структура("APDEX, СреднееВремяВыполнения, КоличествоЗамеров", 0, 0, 0);
            КонецЕсли;
            
            текКоличество = текДанные.КоличествоЗамеров;
            текAPDEX = текДанные.APDEX;
            текСреднее = текДанные.СреднееВремяВыполнения;
            
            новКоличество = СтрокаПроизводительности.КоличествоЗамеров;
            новAPDEX = СтрокаПроизводительности.APDEX;
            новСреднее = СтрокаПроизводительности.СреднееВремяВыполнения;
            
            сумКоличество = текКоличество + новКоличество;
            текДанные.Вставить("APDEX", (текAPDEX * текКоличество + новAPDEX * новКоличество) / сумКоличество);
            текДанные.Вставить("СреднееВремяВыполнения", (текСреднее * текКоличество + новСреднее * новКоличество) / сумКоличество);
            текДанные.Вставить("КоличествоЗамеров", сумКоличество);
            
            текПоказателиПроизводительности.Вставить(СтрокаПроизводительности.ИдентификаторКлючевойОперации, текДанные);
        КонецЦикла;
        
        Для Каждого СтрокаРейтингаИсключений Из Запуск.РейтингИсключенийПоЖурналу Цикл
            текРейтинг = ПредыдущиеТесты.РейтингИсключенийПоЖурналу;
            текДанные = текРейтинг.Получить(СтрокаРейтингаИсключений.ТекстИсключенияХэш);
            Если текДанные = Неопределено Тогда
                текДанные = Новый Структура("КоличествоЗамеров, ОписаниеОшибки, КонтекстИсключения", 
                0, 
                СтрокаРейтингаИсключений.ОписаниеОшибки,
                СтрокаРейтингаИсключений.КонтекстИсключения
                );
            КонецЕсли;
            
            текДанные.Вставить("КоличествоЗамеров", текДанные.КоличествоЗамеров + СтрокаРейтингаИсключений.КоличествоЗамеров);
            текРейтинг.Вставить(СтрокаРейтингаИсключений.ТекстИсключенияХэш, текДанные);
        КонецЦикла;
        
        ПотреблениеПамяти = ПредыдущиеТесты.ПотреблениеПамяти;
        Для Каждого СтрокаПамяти Из Запуск.ПотреблениеПамяти Цикл
            ПотреблениеПамяти.Добавить(Новый Структура(
            "Дата, Значение, Сервер, pid",
            СтрокаПамяти.Дата,
            СтрокаПамяти.Значение,
            СтрокаПамяти.Сервер,
            СтрокаПамяти.pid
            
            ));
        КонецЦикла;
        РеальноеЧислоПредыдущихЗапусков = РеальноеЧислоПредыдущихЗапусков + 1;
        
    КонецЦикла;
    
    
    Если РеальноеЧислоПредыдущихЗапусков = 0 Тогда
        РеальноеЧислоПредыдущихЗапусков = 1;
        ИмеютсяПредыдущиеЗапуски = Ложь;
    Иначе
        ИмеютсяПредыдущиеЗапуски = Истина;
    КонецЕсли;
    
    ПредыдущиеТесты.ТаймаутовНаСУБД = ПредыдущиеТесты.ТаймаутовНаСУБД / Настройки.ЧислоПредыдущихЗапусков;
    ПредыдущиеТесты.ТаймаутовНа1С = ПредыдущиеТесты.ТаймаутовНа1С / Настройки.ЧислоПредыдущихЗапусков;
    ПредыдущиеТесты.ВзаимоблокировокНаСУБД = ПредыдущиеТесты.ВзаимоблокировокНаСУБД / Настройки.ЧислоПредыдущихЗапусков;
    ПредыдущиеТесты.ВзаимоблокировокНа1С = ПредыдущиеТесты.ВзаимоблокировокНа1С / Настройки.ЧислоПредыдущихЗапусков;
    
    ///////////////////////////
    // Новый Тест
    
    Если Настройки.УчитыватьДампы Тогда
        ///////////////////////////////////////////////////
        ///////////////////////////////////////////////////
        // Определяем сколько было дампов и какие они были
        ///////////////////////////////////////////////////
        ///////////////////////////////////////////////////
        
        Запрос = Новый Запрос;
        Запрос.Текст = "ВЫБРАТЬ
        |	Дампы.ВариантДампа.Ссылка КАК ВариантДампа,
        |	КОЛИЧЕСТВО(Дампы.ВариантДампа.Ссылка) КАК КоличествоДамповТекВарианта
        |ИЗ
        |	РегистрСведений.Дампы КАК Дампы
        |ГДЕ
        |	Дампы.Период <= &ДатаОкончания
        |	И Дампы.Период >= &ДатаНачала
        |	И Дампы.ОбъектКонтроля В(&РабочиеСерверы)
        |
        |СГРУППИРОВАТЬ ПО
        |	Дампы.ВариантДампа.Ссылка";
        
        Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДата);
        Запрос.УстановитьПараметр("ДатаНачала", НГраница);
        Запрос.УстановитьПараметр("РабочиеСерверы", Настройки.РабочиеСерверыКластера);
        
        ОбщееЧислоПадений = 0;
        
        ВыборкаДампов = Запрос.Выполнить().Выбрать();
        Пока ВыборкаДампов.Следующий() Цикл
            ВариантДампа = ВыборкаДампов.ВариантДампа;
            КоличествоДамповТекВарианта = ВыборкаДампов.КоличествоДамповТекВарианта;
            ОбщееЧислоПадений = ОбщееЧислоПадений + КоличествоДамповТекВарианта;
            
            СтрокаСтатистикиПоДампам = ИнформацияОЗапуске.Дампы.Добавить();
            СтрокаСтатистикиПоДампам.Количество = КоличествоДамповТекВарианта;
            СтрокаСтатистикиПоДампам.ВариантДампа = ВариантДампа;
            
        КонецЦикла;
        
        ИнформацияОЗапуске.ОбщееЧислоПадений = ОбщееЧислоПадений;
        
        ОбновлятьМожно = ОбновлятьМожно И (ОбщееЧислоПадений = 0);
    КонецЕсли;
    
    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////
    // Статистика по блокировкам
    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////
    
    Если Настройки.УчитыватьИсключения Тогда
        Запрос = Новый Запрос;
        Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДата);
        Запрос.УстановитьПараметр("ДатаНачала", НГраница);
        Запрос.УстановитьПараметр("Кластер", Настройки.Кластер);
        Запрос.УстановитьПараметр("ИнформационнаяБаза", КонтрольнаяПроцедура.ОбъектКонтроля);
        
        Запрос.Текст = "ВЫБРАТЬ
        |	КОЛИЧЕСТВО(*) КАК Количество,
        |	ТехнологическийЖурнал.ВидБлокировки КАК ВидБлокировки
        |ИЗ
        |	РегистрСведений.ТехнологическийЖурнал КАК ТехнологическийЖурнал
        |ГДЕ
        |	ТехнологическийЖурнал.Дата <= &ДатаОкончания
        |	И ТехнологическийЖурнал.Дата >= &ДатаНачала
        |	И ТехнологическийЖурнал.Кластер.Ссылка = &Кластер
        |	И ТехнологическийЖурнал.ИнформационнаяБаза.Ссылка = &ИнформационнаяБаза
        |
        |СГРУППИРОВАТЬ ПО
        |	ТехнологическийЖурнал.ВидБлокировки";
        
        ВыборкаОшибок = Запрос.Выполнить().Выбрать();
        
        // Распределение
        ТабДокСтатистикаПоОшибкам = Новый ТабличныйДокумент;
        ТабДокСтатистикаПоОшибкам.Очистить();
        
        ОбщееЧислоОшибок = 0;
        Распределение = Новый Соответствие;
        Пока ВыборкаОшибок.Следующий() Цикл
            ВидБлокировки = ВыборкаОшибок.ВидБлокировки;
            Количество = ВыборкаОшибок.Количество;
            Распределение.Вставить(ВидБлокировки, Количество);
            ОбщееЧислоОшибок = ОбщееЧислоОшибок + Количество;
        КонецЦикла;
        
        Если Распределение.Получить(Перечисления.ВидыБлокировок.Взаимоблокировка1С) = Неопределено Тогда
            Распределение.Вставить(Перечисления.ВидыБлокировок.Взаимоблокировка1С, 0);
        КонецЕсли;
        Если Распределение.Получить(Перечисления.ВидыБлокировок.ВзаимоблокировкаСУБД) = Неопределено Тогда
            Распределение.Вставить(Перечисления.ВидыБлокировок.ВзаимоблокировкаСУБД, 0);
        КонецЕсли;
        Если Распределение.Получить(Перечисления.ВидыБлокировок.Таймаут1С) = Неопределено Тогда
            Распределение.Вставить(Перечисления.ВидыБлокировок.Таймаут1С, 0);
        КонецЕсли;
        Если Распределение.Получить(Перечисления.ВидыБлокировок.ТаймаутСУБД) = Неопределено Тогда
            Распределение.Вставить(Перечисления.ВидыБлокировок.ТаймаутСУБД, 0);
        КонецЕсли;
        
        ОбновлятьМожно = ОбновлятьМожно И (ОбщееЧислоОшибок = 0);
        
        // ТаймаутовНаСУБД
        ТаймаутовНаСУБД = Распределение.Получить(Перечисления.ВидыБлокировок.ТаймаутСУБД);
        ИнформацияОЗапуске.ТаймаутовНаСУБД = ТаймаутовНаСУБД;
        
        // ТаймаутовНа1С
        ТаймаутовНа1С = Распределение[Перечисления.ВидыБлокировок.Таймаут1С];
        ИнформацияОЗапуске.ТаймаутовНа1С = ТаймаутовНа1С;
        
        // ВзаимоблокировокНаСУБД
        ВзаимоблокировокНаСУБД = Распределение[Перечисления.ВидыБлокировок.ВзаимоблокировкаСУБД];
        ИнформацияОЗапуске.ВзаимоблокировокНаСУБД = ВзаимоблокировокНаСУБД;
        
        // ВзаимоблокировокНа1С
        ВзаимоблокировокНа1С = Распределение[Перечисления.ВидыБлокировок.Взаимоблокировка1С];
        ИнформацияОЗапуске.ВзаимоблокировокНа1С = ВзаимоблокировокНа1С;
        
    КонецЕсли;
    
    //////////////////////////////////////////////////
    // Производительность
    //////////////////////////////////////////////////
    Если Настройки.УчитыватьПроизводительность Тогда
        
        Запрос = Новый Запрос;
        Запрос.Текст = "ВЫБРАТЬ
        |	КлючевыеОперации.Имя,
        |	КлючевыеОперации.УникальныйИдентификатор,
        |	КлючевыеОперации.ЦелевоеВремя,
        |	СРЕДНЕЕ(ЗамерыПроизводительности.Значение) КАК Среднее,
        |	СУММА(
        |	ВЫБОР
        |		КОГДА ЗамерыПроизводительности.Значение <= КлючевыеОперации.ЦелевоеВремя Тогда 1
        |		КОГДА ЗамерыПроизводительности.Значение <= 4 * КлючевыеОперации.ЦелевоеВремя Тогда 0.5
        |		ИНАЧЕ 0
        |	КОНЕЦ) КАК APDEX,
        |	КОЛИЧЕСТВО(*) КАК Количество
        |ИЗ
        |	РегистрСведений.ЗамерыПроизводительности КАК ЗамерыПроизводительности
        |ЛЕВОЕ СОЕДИНЕНИЕ 
        |	РегистрСведений.ОценкаПроизводительностиКлючевыеОперации КАК КлючевыеОперации
        |ПО 
        |	КлючевыеОперации.УникальныйИдентификатор = ЗамерыПроизводительности.ИдентификаторКлючевойОперации
        |ГДЕ
        |	ЗамерыПроизводительности.ОбъектКонтроля = &ИнформационнаяБаза
        |	И ЗамерыПроизводительности.ДатаЗамера <= &ДатаОкончания
        |	И ЗамерыПроизводительности.ДатаЗамера >= &ДатаНачала
        |
        |СГРУППИРОВАТЬ ПО
        |	КлючевыеОперации.УникальныйИдентификатор, КлючевыеОперации.Имя, КлючевыеОперации.ЦелевоеВремя, КлючевыеОперации.Приоритет
        |УПОРЯДОЧИТЬ ПО КлючевыеОперации.Приоритет ";
        
        Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДата);
        Запрос.УстановитьПараметр("ДатаНачала", НГраница);
        Запрос.УстановитьПараметр("ИнформационнаяБаза", КонтрольнаяПроцедура.ОбъектКонтроля);
        Выборка = Запрос.Выполнить().Выбрать();
        
        Пока Выборка.Следующий() Цикл
            КлючеваяОперация = Выборка.Имя;
            ЦелевоеВремя = Выборка.ЦелевоеВремя;
            Среднее = Выборка.Среднее;
            Количество = Выборка.Количество;
            APDEX = Выборка.APDEX / Количество;
            УникальныйИдентификатор = Выборка.УникальныйИдентификатор;
            
            СтрокаПроизводительности = ИнформацияОЗапуске.ПоказателиПроизводительности.Добавить();
            СтрокаПроизводительности.ИдентификаторКлючевойОперации = УникальныйИдентификатор;
            СтрокаПроизводительности.APDEX = APDEX;
            
            предДанные = ПредыдущиеТесты.ПоказателиПроизводительности.Получить(УникальныйИдентификатор);
            Если предДанные <> Неопределено Тогда
                ОбновлятьМожно = ОбновлятьМожно И (предДанные["APDEX"] - APDEX) < Настройки.ДопустимоеОтклонениеПоПроизводительности;
                ОбновлятьМожно = ОбновлятьМожно И (Среднее - предДанные["СреднееВремяВыполнения"]) < Настройки.ДопустимоеОтклонениеПоПроизводительности;
            КонецЕсли;
            СтрокаПроизводительности.СреднееВремяВыполнения = Среднее;
            СтрокаПроизводительности.КоличествоЗамеров = Количество;
            
        КонецЦикла;
        
    КонецЕсли;
    
    //////////////////////////////////////////////////
    // Рейтинг исключений по технологическому журналу 
    //////////////////////////////////////////////////
    
    Если Настройки.УчитыватьБлокировки Тогда 
        Запрос = Новый Запрос;
        Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДата);
        Запрос.УстановитьПараметр("ДатаНачала", НГраница);
        Запрос.УстановитьПараметр("Кластер", Настройки.Кластер);
        Запрос.УстановитьПараметр("ИнформационнаяБаза", КонтрольнаяПроцедура.ОбъектКонтроля);
        
        Запрос.Текст = "ВЫБРАТЬ
        |	КОЛИЧЕСТВО(ТехнологическийЖурнал.ТекстИсключенияХэш) КАК КоличествоИсключенийСДаннымТекстом,
        |	ТехнологическийЖурнал.ТекстИсключенияХэш КАК ТекстИсключенияХэш
        |ПОМЕСТИТЬ РейтингИсключений
        |ИЗ
        |	РегистрСведений.ТехнологическийЖурнал КАК ТехнологическийЖурнал
        |ГДЕ
        |	ТехнологическийЖурнал.Дата <= &ДатаОкончания
        |	И ТехнологическийЖурнал.Дата >= &ДатаНачала
        |	И ТехнологическийЖурнал.Кластер.Ссылка = &Кластер
        |	И ТехнологическийЖурнал.ИнформационнаяБаза.Ссылка = &ИнформационнаяБаза
        |
        |СГРУППИРОВАТЬ ПО
        |	ТехнологическийЖурнал.ТекстИсключенияХэш;
        |
        |/////////////////////////////////
        |
        |ВЫБРАТЬ
        |	ТехнологическийЖурнал.ТекстИсключенияХэш,
        |	МАКСИМУМ(ТехнологическийЖурнал.УникальныйИдентификатор) КАК УникальныйИдентификатор
        |ПОМЕСТИТЬ ИдентификаторыЗаписей
        |ИЗ
        |	РейтингИсключений
        |ЛЕВОЕ СОЕДИНЕНИЕ 
        |	РегистрСведений.ТехнологическийЖурнал КАК ТехнологическийЖурнал
        |ПО 
        |	РейтингИсключений.ТекстИсключенияХэш = ТехнологическийЖурнал.ТекстИсключенияХэш
        |СГРУППИРОВАТЬ ПО
        |	ТехнологическийЖурнал.ТекстИсключенияХэш;
        |
        |/////////////////////////////////
        |
        |ВЫБРАТЬ
        |	РейтингИсключений.КоличествоИсключенийСДаннымТекстом КАК КоличествоИсключенийСДаннымТекстом,
        |	ТехнологическийЖурнал.ТекстИсключения,
        |	ТехнологическийЖурнал.ТекстИсключенияХэш,
        |	ТехнологическийЖурнал.Контекст
        |ИЗ
        |	ИдентификаторыЗаписей
        |
        |ЛЕВОЕ СОЕДИНЕНИЕ 
        |	РегистрСведений.ТехнологическийЖурнал КАК ТехнологическийЖурнал
        |ПО
        |	ИдентификаторыЗаписей.УникальныйИдентификатор = ТехнологическийЖурнал.УникальныйИдентификатор
        |
        |ЛЕВОЕ СОЕДИНЕНИЕ 
        |	РейтингИсключений КАК РейтингИсключений
        |ПО 
        |	РейтингИсключений.ТекстИсключенияХэш = ИдентификаторыЗаписей.ТекстИсключенияХэш
        |
        |УПОРЯДОЧИТЬ ПО РейтингИсключений.КоличествоИсключенийСДаннымТекстом УБЫВ ";
        
        Выборка = Запрос.Выполнить().Выбрать();
        
        Пока Выборка.Следующий() Цикл
            КоличествоОшибок = Выборка.КоличествоИсключенийСДаннымТекстом;
            ТекстИсключения = Выборка.ТекстИсключения;
            КонтекстИсключения = Выборка.Контекст;
            ТекстИсключенияХэш = Выборка.ТекстИсключенияХэш;
            
            СтрокаРейтингаИсключений = ИнформацияОЗапуске.РейтингИсключенийПоЖурналу.Добавить();
            СтрокаРейтингаИсключений.КоличествоЗамеров = КоличествоОшибок;
            СтрокаРейтингаИсключений.ОписаниеОшибки = ТекстИсключения;
            СтрокаРейтингаИсключений.КонтекстИсключения = КонтекстИсключения;
            СтрокаРейтингаИсключений.ТекстИсключенияХэш = ТекстИсключенияХэш;
            
        КонецЦикла;
        
    КонецЕсли;
    //////////////////////////////////////////////////
    // Потребление памяти 
    //////////////////////////////////////////////////
    
    Если Настройки.УчитыватьПотреблениеПамяти Тогда
        Запрос = Новый Запрос;
        Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДата);
        Запрос.УстановитьПараметр("ДатаНачала", НГраница);
        Запрос.УстановитьПараметр("Кластер", Настройки.Кластер);
        Запрос.УстановитьПараметр("ИнформационнаяБаза", КонтрольнаяПроцедура.ОбъектКонтроля);
        
        ЗапросТекст = СтрЗаменить("
        |ВЫБРАТЬ
        |	ОбъединенныйЗапрос.Время КАК Время,
        |	ОбъединенныйЗапрос.ТекущееЗначение КАК ТекущееЗначение,
        |	ОбъединенныйЗапрос.Процесс КАК ОбъектКонтроля,
        |	ОбъединенныйЗапрос.НомерИнтервала КАК НомерИнтервала
        |ПОМЕСТИТЬ ВТ_ВыборкаЗамеров
        |ИЗ
        |(ВЫБРАТЬ
        |	ОсновнаяТаблицаЗамеров.Время КАК Время,
        |	ОсновнаяТаблицаЗамеров.Память КАК ТекущееЗначение,
        |	ОсновнаяТаблицаЗамеров.Сервер + ""__"" + ОсновнаяТаблицаЗамеров.Процесс КАК Процесс,
        |	%ИндексацияИнтервалов
        |
        |ИЗ
        |	РегистрСведений.МониторингПроцессов КАК ОсновнаяТаблицаЗамеров
        |ГДЕ
        |	ОсновнаяТаблицаЗамеров.Кластер = &Кластер
        |	И ОсновнаяТаблицаЗамеров.Время <= &ДатаОкончания
        |	И ОсновнаяТаблицаЗамеров.Время >= &ДатаНачала
        |
        |ОБЪЕДИНИТЬ
        |%ЗапросНаНачальноеЗначение ) КАК ОбъединенныйЗапрос", 
        
        "%ЗапросНаНачальноеЗначение",
        
        "ВЫБРАТЬ
        |	ВложенныйЗапрос.Время КАК Время,
        |	ВложенныйЗапрос.ТекущееЗначение КАК ТекущееЗначение,
        |	ВложенныйЗапрос.Процесс КАК Процесс,
        |	-1 КАК НомерИнтервала
        |ИЗ
        |	(ВЫБРАТЬ ПЕРВЫЕ 1
        |		ОсновнаяТаблицаЗамеров.Время КАК Время,
        |		ОсновнаяТаблицаЗамеров.Память КАК ТекущееЗначение,
        |		ОсновнаяТаблицаЗамеров.Сервер + ""///"" + ОсновнаяТаблицаЗамеров.ПроцессСтрокой КАК Процесс
        |		ИЗ
        |			РегистрСведений.МониторингПроцессов КАК ОсновнаяТаблицаЗамеров
        |		ГДЕ
        |			ОсновнаяТаблицаЗамеров.Кластер = &Кластер
        |			И ОсновнаяТаблицаЗамеров.Время < &ДатаНачала
        |	УПОРЯДОЧИТЬ ПО
        |		Время УБЫВ
        |	) КАК ВложенныйЗапрос ");
        
        ЧислоТочекНаГрафике = 101;
        Шаг = (ТекущаяДата - НГраница) / (ЧислоТочекНаГрафике - 1);
        Замеры = МониторингСервер.ВыбратьДанныеПоРешеткеДат(
        Неопределено,
        НГраница,
        0,
        ЧислоТочекНаГрафике,
        Шаг,
        Запрос,
        ЗапросТекст,
        "Время",
        Шаг,,Истина
        );
        
        НомерТочки = 0;
        МаксимумПотребления = 0;
        Для Каждого ДанныхВТочке Из Замеры Цикл
            
            Дата = НГраница + НомерТочки * Шаг; 
            Максимум = 0;
            Для Каждого ОбъектДанные Из ДанныхВТочке Цикл
                
                СерверПид = ОбъектДанные.Ключ;
                Разделитель = "///";
                ИндексРазделителя = СтрНайти(СерверПид, Разделитель);
                Пид = Прав(СерверПид, СтрДлина(СерверПид) - ИндексРазделителя + 1 - СтрДлина(Разделитель));
                Сервер = Лев(СерверПид, ИндексРазделителя - 1);
                Инфо = ОбъектДанные.Значение;
                
                Среднее = Инфо.Среднее;
                Максимум = Максимум + Инфо.Максимум;
                
                ПотреблениеПамятиСтрока = ИнформацияОЗапуске.ПотреблениеПамяти.Добавить();
                ПотреблениеПамятиСтрока.Дата = Дата;
                ПотреблениеПамятиСтрока.Значение = Среднее;
                ПотреблениеПамятиСтрока.Сервер = Сервер;
                ПотреблениеПамятиСтрока.pid = Пид;
                
            КонецЦикла;
            
            МаксимумПотребления = Макс(Максимум, МаксимумПотребления);
            НомерТочки = НомерТочки + 1;
            
        КонецЦикла;
    КонецЕсли;
    ИнформацияОЗапуске.МаксимумПотребленияПамяти = МаксимумПотребления;
    ИнформацияОЗапуске.ТестПройденУспешно = ОбновлятьМожно;
    
    ИнформацияОЗапуске.Записать();
    
    ////////////////////////////////////////////////
    // Заполнение документа отчета 
    
    ТабДок = Новый ТабличныйДокумент;
    ТабДок.Очистить();
    
    Макет = ПолучитьОбщийМакет("ОтчетПоНагрузочномуТестированию");
    
    Отступ = Макет.ПолучитьОбласть("Отступ");
    
    Шапка = Макет.ПолучитьОбласть("Шапка");
    Шапка.Параметры.Заполнить(Новый Структура(
    "ИмяБазы, ИмяКластера, ДатаНачала, ДатаОкончания, РасположениеАрхивов",
    Настройки.ИмяБазы, Настройки.ИмяКластера, НГраница, ТекущаяДата, Настройки.КаталогВыгрузкиРезультатов
    ));
    ТабДок.Вывести(Шапка);
    ТабДок.Вывести(Отступ);
    
    РешениеОбласть = Макет.ПолучитьОбласть("Решение");
    РешениеОбласть.Параметры.Заполнить(Новый Структура(
    "Решение",
    ?(ИнформацияОЗапуске.ТестПройденУспешно, "МОЖНО", "НЕЛЬЗЯ")
    ));
    ТабДок.Вывести(РешениеОбласть);
    ТабДок.Вывести(Отступ);
    
    ТабДок.Вывести(Макет.ПолучитьОбласть("ТекущиеПоказателиЗаголовок"));
    ТабДок.Вывести(Отступ);
    
    Если ИмеютсяПредыдущиеЗапуски Тогда
        
        ТестоРаздел = Макет.ПолучитьОбласть("ТестоРаздел");
        ТабДок.Вывести(ТестоРаздел);
        
        ПредыдущиеЗапускиЗаголовок = Макет.ПолучитьОбласть("ПредыдущиеЗапускиЗаголовок");
        ТабДок.Вывести(ПредыдущиеЗапускиЗаголовок);
        
        Для Каждого Даты Из ДатыПредыдущихЗапусков Цикл
            ДатаПредыдущегоЗапускаЗаголовок = Макет.ПолучитьОбласть("ДатаПредыдущегоЗапуска");
            ЗаписьДаты = "с %ДатаНачала по %ДатаОкончания";
            ЗаписьДаты = СтрЗаменить(ЗаписьДаты, "%ДатаНачала", Даты.ДатаНачала);
            ЗаписьДаты = СтрЗаменить(ЗаписьДаты, "%ДатаОкончания", Даты.ДатаОкончания);
            ДатаПредыдущегоЗапускаЗаголовок.Параметры.Заполнить(Новый Структура(
            "ДатаПредыдущегоЗапуска",
            ЗаписьДаты
            ));
            ТабДок.Вывести(ДатаПредыдущегоЗапускаЗаголовок);
        КонецЦикла;
        
        СводнаяИнформацияПоДампам = Новый Массив;
        Дампы = ПредыдущиеТесты["Дампы"];
        Для Каждого ДампКоличество Из Дампы Цикл
            СводнаяИнформацияПоДампам.Добавить(Новый Структура(
            "Количество, ВариантДампа",
            ДампКоличество.Значение, ДампКоличество.Ключ
            )); 
        КонецЦикла;
        ПредыдущиеТесты.Вставить("Дампы", СводнаяИнформацияПоДампам);
        
        СводнаяИнформацияПоПроизводительности = Новый Массив;
        ПоказателиПроизводительности = ПредыдущиеТесты.ПоказателиПроизводительности;
        Для Каждого ИдентификаторДанные Из ПоказателиПроизводительности Цикл
            Данные = ИдентификаторДанные.Значение;
            СводнаяИнформацияПоПроизводительности.Добавить(Новый Структура(
            "ИдентификаторКлючевойОперации, Apdex, СреднееВремяВыполнения",
            ИдентификаторДанные.Ключ, Данные.APDEX, Данные.СреднееВремяВыполнения
            )); 
        КонецЦикла;
        ПредыдущиеТесты.Вставить("ПоказателиПроизводительности", СводнаяИнформацияПоПроизводительности);
        
        СводныйРейтингОшибок = Новый ДеревоЗначений;
        СводныйРейтингОшибок.Колонки.Добавить("КоличествоЗамеров");
        СводныйРейтингОшибок.Колонки.Добавить("ОписаниеОшибки");
        СводныйРейтингОшибок.Колонки.Добавить("КонтекстИсключения");
        
        РейтингОшибок = ПредыдущиеТесты.РейтингИсключенийПоЖурналу;
        Для Каждого ХэшДанные Из РейтингОшибок Цикл
            Данные = ХэшДанные.Значение;
            СтрокаРейтинга = СводныйРейтингОшибок.Строки.Добавить();
            СтрокаРейтинга.КоличествоЗамеров = Данные.КоличествоЗамеров;
            СтрокаРейтинга.ОписаниеОшибки = Данные.ОписаниеОшибки;
            СтрокаРейтинга.КонтекстИсключения = Данные.КонтекстИсключения;
        КонецЦикла;
        СводныйРейтингОшибок.Строки.Сортировать("КоличествоЗамеров Убыв");
        РейтингМассив = Новый Массив;
        Для Каждого СтрокаРейтинга Из СводныйРейтингОшибок.Строки Цикл
            РейтингМассив.Добавить(Новый Структура(
            "КоличествоЗамеров, ОписаниеОшибки, КонтекстИсключения",
            СтрокаРейтинга.КоличествоЗамеров,
            СтрокаРейтинга.ОписаниеОшибки,
            СтрокаРейтинга.КонтекстИсключения
            ));
        КонецЦикла;
        ПредыдущиеТесты.Вставить("РейтингИсключенийПоЖурналу", РейтингМассив);
        
        ТабДок.Вывести(Отступ);
        
    КонецЕсли;
    ТабДок.Записать(Настройки.КаталогВыгрузкиРезультатов + ОбщийКлиентСервер.РазделительКаталоговОпределитьПоКаталогу(Настройки.КаталогВыгрузкиРезультатов) + "Нагрузочный тест, база " + Настройки.ИмяБазы + ", с " + Формат(НГраница, "ДФ=""гггг-ММ-дд чч-мм""") + " по " + Формат(ТекущаяДата, "ДФ=""гггг-ММ-дд чч-мм""") + ".mxl");
    
КонецПроцедуры

Процедура ПриОбновлении() Экспорт
	
КонецПроцедуры
