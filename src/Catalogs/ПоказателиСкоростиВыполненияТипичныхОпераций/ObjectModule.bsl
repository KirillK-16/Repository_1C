#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПрограммныйИнтерфейс

Функция ПолучитьДанные(
	Знач ОпорнаяДата,
	Знач НачальноеСмещение,
	Знач ЧислоТочек,
	Знач Шаг, 
	Статистика = Неопределено, 
	ВычислитьАгрегатныеЗначения = Истина, 
	ВычислитьГоризонтАктуальности = Ложь,
	РежимСдвига = Ложь
) Экспорт

    ТаблицаДат = Новый ТаблицаЗначений;
    ТаблицаДат.Колонки.Добавить("Дата", Новый ОписаниеТипов("Число"));
    ДатаНачала = ОпорнаяДата;
    ИндексТочки = 0;
    Пока ИндексТочки < ЧислоТочек Цикл
        
        ДатаТочки = ДатаНачала + ИндексТочки * Шаг;
        
        НовСтрока = ТаблицаДат.Добавить();
        НовСтрока.Дата = ЦЕЛ((ДатаТочки - Дата(1,1,1))/Окр(Шаг)) * Окр(Шаг);
        
        ИндексТочки = ИндексТочки + 1;
        
    КонецЦикла;
    
    Запрос = Новый Запрос;
    Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
    Запрос.Текст = "
    |ВЫБРАТЬ
    |   Дата
    |ПОМЕСТИТЬ
    |   ТаблицаДат   
    |ИЗ
    |   &ТаблицаДат КАК ТаблицаДат
    |ИНДЕКСИРОВАТЬ ПО
    |   Дата
    |;   
    |ВЫБРАТЬ
    |   ИнформационнаяБаза
    |ПОМЕСТИТЬ
    |   ИнформационныеБазы
    |ИЗ
    |   &ИнформационныеБазы КАК ИнформационныеБазы
    |ИНДЕКСИРОВАТЬ ПО
    |   ИнформационнаяБаза
    |;
    |ВЫБРАТЬ
    |   УникальныйИдентификатор
    |ПОМЕСТИТЬ
    |   КлючевыеОперации
    |ИЗ
    |   РегистрСведений.ОценкаПроизводительностиКлючевыеОперации КАК РегСвКлючевыеОперации
    |ГДЕ
    |   РегСвКлючевыеОперации.Имя В (&ИменаКлючевыхОпераций)
    |ИНДЕКСИРОВАТЬ ПО
    |   УникальныйИдентификатор
    |;
    |ВЫБРАТЬ
    |   ВЫРАЗИТЬ(Замеры.ДатаЗамераUTC/(&ПериодАгрегации*1000) - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации КАК Время,
    |   СРЕДНЕЕ(Значение) КАК Значение
    |ПОМЕСТИТЬ
    |   Замеры
    |ИЗ
    |   ИнформационныеБазы КАК ИнформационныеБазы
    |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
    |   КлючевыеОперации КАК КлючевыеОперации
    |ПО
    |   Истина
    |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
    |   РегистрСведений.ЗамерыПроизводительности КАК Замеры
    |ПО
    |   Замеры.ИдентификаторКлючевойОперации = КлючевыеОперации.УникальныйИдентификатор
    |   И Замеры.ОбъектКонтроля = ИнформационныеБазы.ИнформационнаяБаза
    |   И Замеры.ДатаЗамераUTC МЕЖДУ &ДатаНачала И &ДатаОкончания
    |   &УсловиеПользователи
    |СГРУППИРОВАТЬ ПО
    |   ВЫРАЗИТЬ(Замеры.ДатаЗамераUTC/(&ПериодАгрегации*1000) - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации
    |ИНДЕКСИРОВАТЬ ПО
    |   Время
    |;
    |ВЫБРАТЬ
    |   ТаблицаДат.Дата,
    |   Замеры.Значение
    |ИЗ
    |   ТаблицаДат КАК ТаблицаДат
    |ЛЕВОЕ СОЕДИНЕНИЕ
    |   Замеры
    |ПО
    |   Замеры.Время = ТаблицаДат.Дата";
    
    Если ПользователиСсылка.Количество() = 0 Тогда
        Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПользователи", "");
    Иначе
        Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПользователи", "И Замеры.Пользователь В (&Пользователи)");
        Запрос.УстановитьПараметр("Пользователи", ПользователиСсылка.Выгрузить(,"Пользователь")); 
    КонецЕсли;
        
    Запрос.УстановитьПараметр("ТаблицаДат", ТаблицаДат);
    Запрос.УстановитьПараметр("ИнформационныеБазы", ИнформационныеБазы());
    Запрос.УстановитьПараметр("ИменаКлючевыхОпераций", КлючевыеОперации());
    Запрос.УстановитьПараметр("ПериодАгрегации", Окр(Шаг));
    Запрос.УстановитьПараметр("ДатаНачала", (УниверсальноеВремя(ОпорнаяДата, ЧасовойПоясСеанса()) - Дата(1,1,1))*1000);
    Запрос.УстановитьПараметр("ДатаОкончания", (УниверсальноеВремя(ОпорнаяДата + Шаг * ЧислоТочек, ЧасовойПоясСеанса()) - Дата(1,1,1))*1000);
    
    Результат = Запрос.Выполнить();
    
    Выборка = Результат.Выбрать();
    
    Замеры = Новый Массив;
    ТаблицаДляСтатистики = Новый ТаблицаЗначений;
    ТаблицаДляСтатистики.Колонки.Добавить("Замер");
    ПредыдущийЗамер = Неопределено;
    Пока Выборка.Следующий() Цикл
        
        НовСтрока = ТаблицаДляСтатистики.Добавить();
        
        Если Выборка.Значение = NULL Тогда
            
            Если ПредыдущийЗамер = Неопределено Тогда
                ПредыдущийЗамер = ПолучитьПредыдущийЗамер(Запрос, ОпорнаяДата, Окр(Шаг));
            КонецЕсли;
            
            Замеры.Добавить(ПредыдущийЗамер);
            НовСтрока.Замер = ПредыдущийЗамер;        
            
        Иначе
            
            Замеры.Добавить(Выборка.Значение);
            ПредыдущийЗамер = Выборка.Значение;
            НовСтрока.Замер = Выборка.Значение;
            
        КонецЕсли;
        
    КонецЦикла;
    
    АнализДанных = Новый АнализДанных;
    АнализДанных.ТипАнализа = Тип("АнализДанныхОбщаяСтатистика");
	АнализДанных.ИсточникДанных = ТаблицаДляСтатистики;
	РезультатАнализа = АнализДанных.Выполнить();
    
    Статистика.Вставить("Всего", "");
    Статистика.Вставить("Горизонт", ТекущаяДата());
    Статистика.Вставить("Кол", РезультатАнализа.НепрерывныеПоля.Замер.Количество);
    Статистика.Вставить("Макс", РезультатАнализа.НепрерывныеПоля.Замер.Максимум);
    Статистика.Вставить("Мин", РезультатАнализа.НепрерывныеПоля.Замер.Минимум);
    Статистика.Вставить("Сред", РезультатАнализа.НепрерывныеПоля.Замер.Среднее);
    Статистика.Вставить("Сумм", РезультатАнализа.НепрерывныеПоля.Замер.Среднее * РезультатАнализа.НепрерывныеПоля.Замер.Количество);
    Статистика.Вставить("Текущее", Неопределено);
   	
	Возврат Замеры;
	
КонецФункции

Функция ПолучитьДанныеОбнаруженияИнцидентов(ОпорнаяДата, Смещение, АгрегирующаяФункция, ФорматнаяСтрокаЗначения) Экспорт
    
    Статистика = Новый Структура;
    
    ДатаНачала = ОпорнаяДата - Смещение;
	ДатаОкончания = ОпорнаяДата;
    ОбновитьСтатистику(ДатаНачала, ДатаОкончания, Статистика);
    
    Если АгрегирующаяФункция = Перечисления.ФункцииОповещений.Минимум Тогда
		Значение = Статистика.Мин;
	ИначеЕсли АгрегирующаяФункция = Перечисления.ФункцииОповещений.Среднее Тогда
		Значение = Статистика.Сред;
	ИначеЕсли АгрегирующаяФункция = Перечисления.ФункцииОповещений.Максимум Тогда
		Значение = Статистика.Макс;
	ИначеЕсли АгрегирующаяФункция = Перечисления.ФункцииОповещений.Сумма Тогда
		Значение = Статистика.Сумм;
	КонецЕсли;
    
    Данные = Новый Массив;
    Данные.Добавить(Значение);
    Если ЗначениеЗаполнено(ФорматнаяСтрокаЗначения) Тогда
        ИндексНачала = СтрНайти(ФорматнаяСтрокаЗначения, "[");
        ИндексОкончания = СтрНайти(ФорматнаяСтрокаЗначения, "]");
        Если ИндексНачала > 0 И ИндексОкончания > 0 Тогда
            ФорматнаяСтрокаЗначенияБуфер = Сред(ФорматнаяСтрокаЗначения, ИндексНачала + 1, ИндексОкончания - ИндексНачала - 1);
        Иначе
            ФорматнаяСтрокаЗначенияБуфер = ФорматнаяСтрокаЗначения;
        КонецЕсли;
        
        ЗначениеСообщить = СтрЗаменить(ФорматнаяСтрокаЗначения, "[" + ФорматнаяСтрокаЗначенияБуфер + "]", Формат(Значение, ФорматнаяСтрокаЗначенияБуфер));
    Иначе
        ЗначениеСообщить = Значение;
    КонецЕсли;
    
    Сообщить(ЭтотОбъект.Ссылка.Описание + " = " + ЗначениеСообщить);
    
    Возврат Данные;
    
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИнформационныеБазы()
    
    Если ИнформационныеБазы.Количество() > 0 Тогда
        Возврат ИнформационныеБазы.Выгрузить(,"ИнформационнаяБаза");
    Иначе
        Запрос = Новый Запрос;
        Запрос.Текст = "
        |ВЫБРАТЬ
        |   Ссылка КАК ИнформационнаяБаза
        |ИЗ
        |   Справочник.ОбъектыКонтроля
        |ГДЕ
        |   Владелец = &ИнформационнаяБаза
        |";
        Запрос.УстановитьПараметр("ИнформационнаяБаза", Справочники.ВидыОбъектовКонтроля.ИнформационнаяБаза);
        Возврат Запрос.Выполнить().Выгрузить();
    КонецЕсли;
        
КонецФункции

Функция КлючевыеОперации()
    
    Если КлючевыеОперации.Количество() > 0 Тогда
        КлючевыеОперации.ВыгрузитьКолонку("Наименование");
    Иначе
        Запрос = Новый Запрос;
        Запрос.Текст = "
        |ВЫБРАТЬ РАЗЛИЧНЫЕ
        | Имя КАК Наименование
        |ИЗ
        |   РегистрСведений.ОценкаПроизводительностиКлючевыеОперации
        |";
        Возврат Запрос.Выполнить().Выгрузить();
    КонецЕсли;
    
КонецФункции


Функция ПолучитьПредыдущийЗамер(Запрос, ДатаНачала, Шаг)
    
    Запрос.Текст = "
    |ВЫБРАТЬ
    |   МАКСИМУМ(ДатаЗамераUTC) КАК Время
    |ИЗ
    |   РегистрСведений.ЗамерыПроизводительности КАК Замеры
    |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
    |   ИнформационныеБазы КАК ИнформационныеБазы
    |ПО
    |   ИнформационныеБазы.ИнформационнаяБаза = Замеры.ОбъектКонтроля
    |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
    |   КлючевыеОперации КАК КлючевыеОперации
    |ПО
    |   КлючевыеОперации.УникальныйИдентификатор = Замеры.ИдентификаторКлючевойОперации
    |ГДЕ
    |   Замеры.ДатаЗамераUTC < &ДатаНачала
    |";
    
    Запрос.УстановитьПараметр("ДатаНачала", (УниверсальноеВремя(ДатаНачала, ЧасовойПоясСеанса()) - Дата(1,1,1))*1000);
    
    Результат = Запрос.Выполнить();
    
    Если НЕ Результат.Пустой() Тогда
        
        Выборка = Результат.Выбрать();
        Выборка.Следующий();
        
        Если Выборка.Время <> NULL Тогда
            
            Запрос.Текст = "
            |ВЫБРАТЬ
            |   СРЕДНЕЕ(Значение) КАК Значение
            |ИЗ
            |   ИнформационныеБазы КАК ИнформационныеБазы
            |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
            |   КлючевыеОперации КАК КлючевыеОперации
            |ПО
            |   Истина
            |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
            |   РегистрСведений.ЗамерыПроизводительности КАК Замеры
            |ПО
            |   Замеры.ИдентификаторКлючевойОперации = КлючевыеОперации.УникальныйИдентификатор
            |   И Замеры.ОбъектКонтроля = ИнформационныеБазы.ИнформационнаяБаза
            |   И Замеры.ДатаЗамераUTC МЕЖДУ &ДатаНачала И &ДатаОкончания
            |";
            
            Запрос.УстановитьПараметр("ДатаНачала", Выборка.Время - Шаг*1000);
            Запрос.УстановитьПараметр("ДатаОкончания", Выборка.Время);
            
            Результат = Запрос.Выполнить();
            Выборка = Результат.Выбрать();
            Выборка.Следующий();
            
            Возврат Выборка.Значение;
            
        Иначе
            Возврат 0;
        КонецЕсли;
        
    Иначе
        Возврат 0;
    КонецЕсли;
        
КонецФункции

Функция ОбновитьСтатистику(Знач ДатаНачала, Знач ДатаОкончания, Статистика) Экспорт
	
	Запрос = Новый Запрос;
	Условие = УсловиеНаПользователей(Запрос);
	
	Если Условие <> ВырожденноеУсловие() Тогда
		
		ЗапросБуфер = Новый Запрос;
		МониторингСервер.УстановитьПараметрыДатыВЗапросе(ЗапросБуфер, ДатаНачала, ДатаОкончания, Истина);
		
		Запрос.УстановитьПараметр("ДатаНачала", (ЗапросБуфер.Параметры.ДатаНачала - Дата(1,1,1))*1000);
		Запрос.УстановитьПараметр("ДатаОкончания", (ЗапросБуфер.Параметры.ДатаОкончания - Дата(1,1,1))*1000);
		
		Запрос.УстановитьПараметр("ИнформационнаяБаза", ЭтотОбъект.ИнформационнаяБаза);
		Запрос.УстановитьПараметр("ИдентификаторКлючевойОперации", ЭтотОбъект.ИдентификаторКлючевойОперации);
		
		ЗапросТекст = "
		|ВЫБРАТЬ
		|	СРЕДНЕЕ(ВложенныйЗапрос.ТекущееЗначение) КАК Сред,
		|	МАКСИМУМ(ВложенныйЗапрос.ТекущееЗначение) КАК Макс,
		|	МИНИМУМ(ВложенныйЗапрос.ТекущееЗначение) КАК Мин,
		|	СУММА(ВложенныйЗапрос.ТекущееЗначение) КАК Всего,
		|	КОЛИЧЕСТВО(ВложенныйЗапрос.ТекущееЗначение) КАК Кол
		|
		|ИЗ
		|(ВЫБРАТЬ
		|	ОсновнаяТаблицаЗамеров.Значение КАК ТекущееЗначение
		|
		|ИЗ
		|	РегистрСведений.ЗамерыПроизводительности КАК ОсновнаяТаблицаЗамеров
		|ГДЕ
		|	ОсновнаяТаблицаЗамеров.ОбъектКонтроля = &ИнформационнаяБаза
		|	И ОсновнаяТаблицаЗамеров.ДатаЗамераUTC >= &ДатаНачала
		|	И ОсновнаяТаблицаЗамеров.ДатаЗамераUTC <= &ДатаОкончания
		|	И ОсновнаяТаблицаЗамеров.ИдентификаторКлючевойОперации = &ИдентификаторКлючевойОперации
		|	%1 	
		|) КАК ВложенныйЗапрос";
		
		
		ЗапросТекст = СтрЗаменить(ЗапросТекст, "%1", Условие);
		Запрос.Текст = ЗапросТекст;
		
		ПоследнееСреднее = Неопределено;
        Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() И Выборка.Кол > 0 Тогда
			Статистика.Вставить("Сред", Выборка.Сред);
			Статистика.Вставить("Макс", Выборка.Макс);
			Статистика.Вставить("Мин", Выборка.Мин);
            Статистика.Вставить("Сумм", Выборка.Всего);
			Статистика.Вставить("Всего", Выборка.Всего);
			ПоследнееСреднее = Выборка.Сред;
			
		Иначе
			Статистика.Вставить("Сред", 0);
			Статистика.Вставить("Макс", 0);
			Статистика.Вставить("Мин", 0);
            Статистика.Вставить("Сумм", 0);
			Статистика.Вставить("Всего", 0);
		КонецЕсли;
		Статистика.Вставить("Кол", Выборка.Кол);
		
	Иначе
		Статистика.Вставить("Сред", 0);
		Статистика.Вставить("Макс", 0);
		Статистика.Вставить("Мин", 0);
		Статистика.Вставить("Всего", 0);
        Статистика.Вставить("Сумм", 0);
		Статистика.Вставить("Кол", 0);
	КонецЕсли;
	
	// вычислим параметр "Текущее" 
	Попытка
		Если Статистика.Кол > 0 Тогда
			ТекущееЗначение = ПоследнееСреднее;
		Иначе 
			ТекущееЗначение = 0;
		КонецЕсли;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Комментарий =
			"Описание = '" +Инфо.Описание + "', " +
			"ИмяМодуля = '" + Инфо.ИмяМодуля + "', " +
			"НомерСтроки = '" + Инфо.НомерСтроки + "', " +
			"ИсходнаяСтрока = '" + Инфо.ИсходнаяСтрока + "'.";
			
		ЗаписьЖурналаРегистрации(
			"Функция ОбновитьСтатистику(Знач ДатаНачала, Знач ДатаОкончания, Статистика) Экспорт",
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.ПоказателиСкоростиВыполненияТипичныхОпераций.МодульОбъекта,
			,
			Комментарий);
			
		ТекущееЗначение = 0;
	КонецПопытки;
	Статистика.Вставить("Текущее", ТекущееЗначение);
	
КонецФункции

Функция УсловиеНаПользователей(Запрос)
	Если ЭтотОбъект.ТипСпискаПользователей = Перечисления.ТипыСпискаПользователей.Все Тогда
		
		Возврат " ";
		
	Иначе
			
		ВыбранныеПользователи = Новый Массив;
		Для Каждого ПользовательСтрока Из ЭтотОбъект.Пользователи Цикл
			
			ВыбранныеПользователи.Добавить(ПользовательСтрока.ИмяПользователя);
			
		КонецЦикла;
		
		ИмеютсяПользователи = ВыбранныеПользователи.Количество();
		Если ИмеютсяПользователи Тогда 
			
			Запрос.УстановитьПараметр("Пользователи", ВыбранныеПользователи);
			
			Если ЭтотОбъект.ТипСпискаПользователей = Перечисления.ТипыСпискаПользователей.ВсеКроме Тогда
				Условие = " И НЕ ОсновнаяТаблицаЗамеров.Пользователь В (&Пользователи) ";
			Иначе
				Условие = " И ОсновнаяТаблицаЗамеров.Пользователь В (&Пользователи) ";
			КонецЕсли;
		
		Иначе
			Если ЭтотОбъект.ТипСпискаПользователей = Перечисления.ТипыСпискаПользователей.ВсеКроме Тогда
				Условие = " ";
			Иначе
				Возврат ВырожденноеУсловие();
			КонецЕсли;
		КонецЕсли;
		Возврат Условие;
	КонецЕсли;
	
КонецФункции

Функция ВырожденноеУсловие()
	Возврат "___вырожденное_условие___";
КонецФункции

Функция ИдентификаторВариантаПоказателя() Экспорт
	
	ФильтрПоОбъектамКонтроля = Новый Массив;
	ФильтрПоОбъектамКонтроля.Добавить(Новый Структура(
		"НазваниеРеквизитаВсеОбъектыКонтроля, НазваниеРеквизитаОбъектКонтроля",
		Неопределено,
		"ИнформационнаяБаза"
	));
	
	ИД = МониторингСервер.ОбщаяЧастьИдентификатораВариантаПоказателя(
		ЭтотОбъект,
		ФильтрПоОбъектамКонтроля
	);
	
	РазделительПолей = "__";
	ИД = ИД + ЭтотОбъект.ИдентификаторКлючевойОперации + РазделительПолей;
	ИД = ИД + Строка(ЭтотОбъект.ТипСпискаПользователей) + РазделительПолей;
	
	Если ЭтотОбъект.ТипСпискаПользователей <> Перечисления.ТипыСпискаПользователей.Все Тогда
		ПользователиВТаблицу = ЭтотОбъект.Пользователи.ВыгрузитьКолонки("ИмяПользователя");
		Для Каждого ПользовательСтрока Из  ЭтотОбъект.Пользователи Цикл
			ВремСтрока = ПользователиВТаблицу.Добавить();
			ВремСтрока.ИмяПользователя = ПользовательСтрока.ИмяПользователя;
		КонецЦикла;
		
		ПользователиВТаблицу.Сортировать("ИмяПользователя");
		Для Каждого ПользовательСтрока Из ПользователиВТаблицу Цикл
			ИД = ИД + "_" + ПользовательСтрока.ИмяПользователя;
		КонецЦикла;
	КонецЕсли;
	Возврат ИД;
КонецФункции

// Возвращает текстовую строку, описывающую тип показателя
//
// Возвращаемое значение:
//  Строка
//
Функция ИдентификаторТипаПоказателя() Экспорт
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Метаданные().РасширенноеПредставлениеОбъекта) Тогда
		Возврат ЭтотОбъект.Метаданные().РасширенноеПредставлениеОбъекта;
	ИначеЕсли ЗначениеЗаполнено(ЭтотОбъект.Метаданные().ПредставлениеОбъекта) Тогда
		Возврат ЭтотОбъект.Метаданные().ПредставлениеОбъекта;
	Иначе
		Возврат ЭтотОбъект.Метаданные().Синоним;
	КонецЕсли;
	
КонецФункции

// Заполняет параметры по умолчанию отображения показателя на графике
// 
// Параметры:
//  ПараметрОповещения - Структура - см.МониторингСервер.ПараметрОповещенияПоказательЗаписан()
//
Процедура ЗаполнитьПараметрыОтображенияПоУмолчанию(Знач ПараметрОповещения) Экспорт
	ГСЧ = Новый ГенераторСлучайныхЧисел();
	
	ПараметрОповещения.Цвет = Новый Цвет(ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255));
	ПараметрОповещения.АвтоМасштаб = Истина;
	ПараметрОповещения.Масштаб = 1;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Описание) Тогда
		Описание = Описание();
	КонецЕсли;
	
КонецПроцедуры

Функция Описание()
	
	КлючеваяОперация = РегистрыСведений.ОценкаПроизводительностиКлючевыеОперации.Получить(
		Новый Структура("УникальныйИдентификатор, ИнформационнаяБаза", ИдентификаторКлючевойОперации, ИнформационнаяБаза)).Имя;
	ПользователиВСтроку = СписокПользователей();
	НаименованиеВСтроку = ИдентификаторТипаПоказателя()
		+ " (" + ИнформационнаяБаза
		+ ?(ПустаяСтрока(КлючеваяОперация), "", ", " + КлючеваяОперация)
		+ ПользователиВСтроку
		+ ")";
	
	Возврат НаименованиеВСтроку;
КонецФункции

Функция СписокПользователей()
	
	Если ТипСпискаПользователей = Перечисления.ТипыСпискаПользователей.Все Тогда
		Возврат "";
	КонецЕсли;
	
	СписокВСтроку = "";
	
	НачалоСписка = Истина;
	Для Каждого ПользовательСтрока Из Пользователи Цикл
		Если НачалоСписка Тогда
			НачалоСписка = Ложь;
		Иначе
			СписокВСтроку = СписокВСтроку + ", ";
		КонецЕсли;
		ИмяПользователя = ПользовательСтрока.ИмяПользователя;
		Если ПустаяСтрока(ИмяПользователя) Тогда
			ИмяПользователя = "<пустое имя>";
		КонецЕсли;
		СписокВСтроку = СписокВСтроку + ИмяПользователя;
	КонецЦикла;
	
	Если ТипСпискаПользователей = Перечисления.ТипыСпискаПользователей.ВсеКроме Тогда
		Возврат ", Кроме пользователей: " + СписокВСтроку;
	Иначе
		Возврат ", Пользователи: " + СписокВСтроку;
	КонецЕсли;
КонецФункции

// Расчитывает данные показателя по периодам
//
//	Параметры:
// 		МенеджерВременныхТаблиц	- МенеджерВременныхТаблиц. Временные таблицы с периодами и показателями.
// 		Детализация				- ТипДополненияПериодаКомпоновкиДанных. Период детализации.
//
//	Возвращаемое значение:
//		ТаблицаДанных. ТаблицаЗначений. Данные показателя.
//
Функция РасчитатьПоказатель(МенеджерВременныхТаблиц, Детализация = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ПоказательМониторинга", ЭтотОбъект.Владелец);
	Запрос.УстановитьПараметр("Показатель", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("ИдентификаторКлючевойОперации", ИдентификаторКлючевойОперации);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаПодготовительная.ДатаТочки КАК ДатаТочки,
	|	СРЕДНЕЕ(ЕСТЬNULL(ОсновнаяТаблицаЗамеров.Значение, 0)) КАК Максимальное,
	|	СРЕДНЕЕ(ЕСТЬNULL(ОсновнаяТаблицаЗамеров.Значение, 0)) КАК Минимальное,
	|	СРЕДНЕЕ(ЕСТЬNULL(ОсновнаяТаблицаЗамеров.Значение, 0)) КАК Значение
	|ИЗ
	|	ТаблицаПодготовительная КАК ТаблицаПодготовительная
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамерыПроизводительности КАК ОсновнаяТаблицаЗамеров
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПоказателиСкоростиВыполненияТипичныхОпераций КАК ПоказателиСкоростиВыполненияТипичныхОпераций
	|		ПО ОсновнаяТаблицаЗамеров.ОбъектКонтроля = ПоказателиСкоростиВыполненияТипичныхОпераций.ИнформационнаяБаза
	|		И ПоказателиСкоростиВыполненияТипичныхОпераций.ИдентификаторКлючевойОперации = &ИдентификаторКлючевойОперации
	|		И ПоказателиСкоростиВыполненияТипичныхОпераций.Ссылка = &Показатель
	|
	|	ПО ТаблицаПодготовительная.ПоказательМониторинга = &ПоказательМониторинга
	|	И ОсновнаяТаблицаЗамеров.ДатаЗамера > ТаблицаПодготовительная.ДатаТочкиДанные
	|	И ОсновнаяТаблицаЗамеров.ДатаЗамера <= ТаблицаПодготовительная.ДатаТочкиДанныеСледующая
	|	И &УсловиеПользователи
	|
	|ГДЕ
	|	ТаблицаПодготовительная.ПоказательМониторинга = &ПоказательМониторинга
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПодготовительная.ДатаТочки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаТочки
	|";
	
	Если ТипСпискаПользователей = Перечисления.ТипыСпискаПользователей.ВсеКроме Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПользователи", "НЕ ОсновнаяТаблицаЗамеров.Пользователь В(ВЫБРАТЬ ПользователиЗамерПроизводительности.Ссылка ИЗ ПользователиЗамерПроизводительности)");
	ИначеЕсли ТипСпискаПользователей = Перечисления.ТипыСпискаПользователей.ТолькоУказанные Тогда                                                                                                            
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПользователи", "ОсновнаяТаблицаЗамеров.Пользователь В(ВЫБРАТЬ ПользователиЗамерПроизводительности.Ссылка ИЗ ПользователиЗамерПроизводительности)");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПользователи", "Истина");
	КонецЕсли;
	
	ТаблицаДетальныхДанных = Запрос.Выполнить().Выгрузить();
	
	МассивПолей = Новый Массив();
	МассивПолей.Добавить("Значение");
	
	РасчетИтоговПоказателей.ЗаполнитьПустыеДанныеПредыдущимиЗначениями(ТаблицаДетальныхДанных, МассивПолей, Null);
	
	Если ЭтотОбъект.Владелец.ПоказыватьТренд Тогда
		РасчетИтоговПоказателей.СгладитьДанные(ТаблицаДетальныхДанных, ЭтотОбъект.Владелец.ТипСглаживания, ЭтотОбъект.Владелец.КоличествоУсредняемыхЗначений);
	КонецЕсли;
	
	Возврат ТаблицаДетальныхДанных;
	
КонецФункции

#КонецОбласти

#КонецЕсли