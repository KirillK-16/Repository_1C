#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Общие настройки

Перем ТекстОшибки;
Перем ЗадачаОшибкаПриАнализе;
Перем ОбязательныеНастройки;
Перем НетПроблем;
Перем ИмяСтраницыСправки;

// Настройки контрольной процедуры
Перем МаксимальнаяДатаПрочитанныхЗаписейСкрыто;
Перем КаталогЖурналРегистрации;
Перем ДопустимаяДлительностьВыполнения;

// Вспомогательные переменные
Перем СобытиеСтарт;
Перем СобытиеЗавершеноУспешно;
Перем СобытиеЗавершеноСОшибками;

//////////////////////
// Общие функции
//////////////////////



Процедура ПроверкаНаНаличиеОшибокВыполнения(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = ТекстОшибки <> Неопределено;
КонецПроцедуры

Процедура КонтрольнаяПроцедураЗавершенаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = НЕ КонтрольнаяПроцедура.Выполнять;
КонецПроцедуры

//////////////////
// Разбор Настроек
//////////////////

Процедура ЕстьНезаполненныеНастройкиПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Ошибки = Новый Массив;
	Для Каждого Настройка Из ОбязательныеНастройки Цикл		
		Если НЕ ЗначениеЗаполнено(Настройка.Значение) Тогда
			Ошибки.Добавить(Настройка.Ключ);
		КонецЕсли;
	КонецЦикла;	
	Если Ошибки.Количество() > 0 Тогда
		ТекстОшибки = "В объекте " + Строка(КонтрольнаяПроцедура.ОбъектКонтроля) + " не определены следующие настройки: "; 	
		ТекстОшибки = ТекстОшибки + Символы.ПС + " - " + ОбщийКлиентСервер.ОбъединитьСтроку(Ошибки, Символы.ПС + " - ");
		Результат = Истина;
		ИмяСтраницыСправки = "НеЗаполненыНастройкиВОбъектеКонтроля";

	Иначе	
		Результат = Ложь;
	КонецЕсли;
		
КонецПроцедуры

Процедура РазобратьНастройкиОбработка(ТочкаМаршрутаБизнесПроцесса)
	ТекстОшибки = Неопределено;
	Попытка
		РазобратьНастройки();
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ИмяСтраницыСправки = "НеизвестнаяОшибка";
		Отладка.Ошибка(ТекстОшибки);
		
	КонецПопытки;
КонецПроцедуры

Процедура РазобратьНастройки()
	ОбязательныеНастройки = Новый Соответствие;
	
	// Чтение настроек
	// Чтение настроек
	НастройкиСловарь = РегистрыСведений.НастройкиКонтрольРегламентныхЗаданий.Получить(
		Новый Структура("КонтрольнаяПроцедура", КонтрольнаяПроцедура)
	);		
	МаксимальнаяДатаПрочитанныхЗаписейСкрыто = НастройкиСловарь.МаксимальнаяДатаПрочитанныхЗаписейСкрыто;
	
	ДопустимаяДлительностьВыполнения = НастройкиСловарь.ДопустимаяДлительностьВыполнения;
	ОбязательныеНастройки.Вставить("Максимально допустимое время выполнения фоновых заданий в секундах", ДопустимаяДлительностьВыполнения);
	
	НастройкиСловарь = РегистрыСведений.ПараметрыИнформационныхБаз.Получить(
		Новый Структура("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля)
	);
	КаталогЖурналРегистрации = НастройкиСловарь.КаталогЖурналРегистрации;
	ОбязательныеНастройки.Вставить("Каталог журнал регистрации", КаталогЖурналРегистрации);

КонецПроцедуры

/////////////////////
// Формирование задач
/////////////////////

Функция СоздатьЗадачуОтветственномуЗаВыполнение(ТекстПоручения)
	
	Возврат Неопределено;
	
КонецФункции	

Процедура СформироватьСписокЗадач(ФормируемыеЗадачи, ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса)
	ФормируемыеЗадачи.Очистить();		
	
	ЗадачаОбъект = ЗадачаСсылка.ПолучитьОбъект();
	Если ЗадачаОбъект.БизнесПроцесс = Неопределено И ЗадачаОбъект.ТочкаМаршрута = Неопределено Тогда 
		БизнесПроцессСервер.ПривязатьЗадачуКТочкеМаршрута(ЭтотОбъект.Ссылка, ЗадачаОбъект, ТочкаМаршрутаБизнесПроцесса);	
	КонецЕсли;
	ЗадачаОбъект.Выполнена = Ложь;
	ФормируемыеЗадачи.Добавить(ЗадачаОбъект);
	
КонецПроцедуры	

Процедура УстранитьПричиныНевозможностиАнализаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗадачаОшибкаПриАнализе = СоздатьЗадачуОтветственномуЗаВыполнение(ТекстОшибки);
	СформироватьСписокЗадач(ФормируемыеЗадачи, ЗадачаОшибкаПриАнализе, ТочкаМаршрутаБизнесПроцесса);
КонецПроцедуры

Процедура НачатьПроверкуПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//здесь надо переиспользовать задачу
	ЗадачаПоПерезапуску = БизнесПроцессСервер.НайтиЗадачуПерезапуска(ЭтотОбъект.Ссылка);
	СформироватьСписокЗадач(ФормируемыеЗадачи, ЗадачаПоПерезапуску, ТочкаМаршрутаБизнесПроцесса);
КонецПроцедуры

////////////////////////
// Анализ
////////////////////////

Процедура ВыполнитьАнализОбработка(ТочкаМаршрутаБизнесПроцесса)
	ТекстОшибки = Неопределено;
	Попытка 
		ВыполнитьАнализ();
	Исключение
		
		НетПроблем = Неопределено;
		ИмяСтраницыСправки = "НеизвестнаяОшибка";
		Сообщение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Отладка.Ошибка(Сообщение);
		СоздатьЗадачуОтветственномуЗаВыполнение(Сообщение);
		
	КонецПопытки;

КонецПроцедуры	

Процедура ВыполнитьАнализ()
	
	НетПроблем = Истина;
	
	СобытиеСтарт = "Очередь регламентных заданий.Старт";
	СобытиеЗавершеноУспешно = "Очередь регламентных заданий.Завершено успешно";
	СобытиеЗавершеноСОшибками = "Очередь регламентных заданий.Завершено с ошибками";
	
	ТекущаяДатаСервер = ТекущаяДата();
	ТекущаяГраницаПоиска = ?(
		ТекущаяДатаСервер - МаксимальнаяДатаПрочитанныхЗаписейСкрыто > 600,
		ТекущаяДатаСервер - 600,
		МаксимальнаяДатаПрочитанныхЗаписейСкрыто
	);
	ГраницаПоиска = ТекущаяДата();
			
	ТаблицаВыгрузки = Новый ТаблицаЗначений;
	  		
	ПрочитатьЖурналРегистрации(ТаблицаВыгрузки, ТекущаяГраницаПоиска, ГраницаПоиска);
	
	Если ТаблицаВыгрузки.Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Восстановить работоспособность регламентных заданий в информационной базе'");
		НетПроблем = Ложь;
		
	КонецЕсли;
	
	КопияТаблицыВыгрузки = ТаблицаВыгрузки.Скопировать();
	
	ПроверитьПервуюСекунду(ТаблицаВыгрузки, ТекущаяГраницаПоиска);	
	УдалитьПарыНачалоКонец(КонтрольнаяПроцедура, ТаблицаВыгрузки);
	ОбработатьЗавершенныеЗадания(КопияТаблицыВыгрузки);
	
	Выборка = ПолучитьПросроченныеРегламентныеЗадания(КонтрольнаяПроцедура);
	Пока Выборка.Следующий() Цикл
		
		УдалитьЗаписьРегистра(КонтрольнаяПроцедура, Выборка.НомерСеансаФоновогоЗадания, Выборка.ОбластьДанных);
		СоздатьЗадачуПоРегламентномуЗаданию(
			Выборка.НомерСеансаФоновогоЗадания, 
			Выборка.ИмяМетодаРегламентногоЗадания, 
			Выборка.ОбластьДанных,
			Истина
		);
        НетПроблем = Ложь;
		
	КонецЦикла;
	
	ЗафиксироватьНовыеНачалаРегламентныхЗаданий(КонтрольнаяПроцедура, ТаблицаВыгрузки);
	
	НаборЗаписейСНастройками = РегистрыСведений.НастройкиКонтрольРегламентныхЗаданий.СоздатьНаборЗаписей();	
	НаборЗаписейСНастройками.Отбор.КонтрольнаяПроцедура.Установить(КонтрольнаяПроцедура);
	НаборЗаписейСНастройками.Прочитать();
	НастройкиЗапись = НаборЗаписейСНастройками[0];
	НастройкиЗапись.МаксимальнаяДатаПрочитанныхЗаписейСкрыто = ГраницаПоиска;
	НаборЗаписейСНастройками.Записать();
	
КонецПроцедуры

////////////////////////
// Вспомогательные Функции
////////////////////////

Процедура ПрочитатьЖурналРегистрации(ТаблицаВыгрузки, ВГраница, НГраница)
	
	ИскомыеСобытия = Новый Массив;
	ИскомыеСобытия.Добавить(СобытиеСтарт);
	ИскомыеСобытия.Добавить(СобытиеЗавершеноУспешно);
	ИскомыеСобытия.Добавить(СобытиеЗавершеноСОшибками);
	
	Фильтр = Новый Структура("ДатаНачала,ДатаОкончания,Уровень,Событие");	
	Фильтр.ДатаНачала = ВГраница;
	Фильтр.ДатаОкончания = НГраница;
	Фильтр.Уровень = УровеньЖурналаРегистрации.Информация;
	Фильтр.Событие = ИскомыеСобытия;
	
	ЧастиПутиКЖурналу = Новый Массив;
	ЧастиПутиКЖурналу.Добавить(КаталогЖурналРегистрации);
	
	
	НайденныеФайлы = НайтиФайлы(КаталогЖурналРегистрации, "1Cv8.lgd", Ложь);
	Если НайденныеФайлы.Количество() = 1 Тогда
		ВызватьИсключение(НСтр("ru = 'Формат журнала регистрации 1Cv8.lgd не поддерживается.'"));
	Иначе
		ЧастиПутиКЖурналу.Добавить("1Cv8.lgf");
	КонецЕсли;
	ПутьКЖурналуРегистрации = ОбщийКлиентСервер.СформироватьПуть(ЧастиПутиКЖурналу);

	ВыгрузитьЖурналРегистрации(ТаблицаВыгрузки, Фильтр, "Дата,Событие,Комментарий,Сеанс", ПутьКЖурналуРегистрации);
		
	ТаблицаВыгрузки.Колонки.Добавить("НомерСтрокиЖурнала");
	ТаблицаВыгрузки.Колонки.Добавить("ИмяМетодаРегламентногоЗадания");
	ТаблицаВыгрузки.Колонки.Добавить("ОбластьДанных");
	
	НомерСтрокиЖурнала = 0;
	Для Каждого СтрокаТаблицы Из ТаблицаВыгрузки Цикл
		НомерСтрокиЖурнала = НомерСтрокиЖурнала + 1;
		СтрокаТаблицы.НомерСтрокиЖурнала = НомерСтрокиЖурнала;
		
		КомментарийСтруктура = РазобратьКомментарийЖурналаРегистрации(СтрокаТаблицы.Комментарий);
		СтрокаТаблицы.ИмяМетодаРегламентногоЗадания = КомментарийСтруктура.ИмяМетодаРегламентногоЗадания;
		СтрокаТаблицы.ОбластьДанных = КомментарийСтруктура.ОбластьДанных;
	КонецЦикла;
	ТаблицаВыгрузки.Колонки.Удалить("Комментарий");
	
КонецПроцедуры

Функция РазобратьКомментарийЖурналаРегистрации(КомментарийЖурналаРегистрации)
	Значения = ОбщийКлиентСервер.РазделитьСтроку(КомментарийЖурналаРегистрации, ";");
	ЧислоЗначений = Значения.Количество();
	ИмяМетода = "";
	НомерЗначения = 0;
	Пока НомерЗначения < ЧислоЗначений - 1 Цикл
		ИмяМетода = ИмяМетода + Значения[НомерЗначения];
		НомерЗначения = НомерЗначения + 1;
	КонецЦикла;
	
	Возврат Новый Структура("ИмяМетодаРегламентногоЗадания, ОбластьДанных", ИмяМетода, Значения[ЧислоЗначений - 1]);
КонецФункции

Процедура ПроверитьПервуюСекунду(ТаблицаВыгрузки, ТекущаяГраницаПоиска)
	
	Если ТаблицаВыгрузки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписиПервойСекунды = ТаблицаВыгрузки.СкопироватьКолонки();
	Пока ТаблицаВыгрузки.Количество() > 0 И ТаблицаВыгрузки[0].Дата = ТекущаяГраницаПоиска Цикл
		НоваяСтрока = ЗаписиПервойСекунды.Добавить();
		Для Каждого Колонка Из ТаблицаВыгрузки.Колонки Цикл
			НоваяСтрока[Колонка.Имя] = ТаблицаВыгрузки[0][Колонка.Имя];
		КонецЦикла;
		ТаблицаВыгрузки.Удалить(0);
	КонецЦикла;
	
	Если ЗаписиПервойСекунды.Количество() <> 0 Тогда
		ОбработатьЗавершенныеЗадания(ЗаписиПервойСекунды);
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьПарыНачалоКонец(КонтрольнаяПроцедура, ТЗ)
	
	ТекущееКоличество = ТЗ.Количество();
	Если ТекущееКоличество = 0 Тогда
		Возврат;
	КонецЕсли;
	ТЗ.Сортировать("Сеанс,ОбластьДанных,Дата,НомерСтрокиЖурнала");
	
	Сч = 0;
	Пока ТекущееКоличество - 1 > Сч Цикл
		
		Если ТЗ[Сч].Сеанс = ТЗ[Сч + 1].Сеанс И ТЗ[Сч].ОбластьДанных = ТЗ[Сч + 1].ОбластьДанных И ВРег(ТЗ[Сч].Событие) = ВРег(СобытиеСтарт) Тогда
			
			Если ВРег(ТЗ[Сч + 1].Событие) = ВРег(СобытиеЗавершеноСОшибками) Тогда
				СоздатьЗадачуПоРегламентномуЗаданию(
					ТЗ[Сч + 1].Сеанс, 
					ТЗ[Сч + 1].ИмяМетодаРегламентногоЗадания, 
					ТЗ[Сч + 1].ОбластьДанных,
					Ложь
				);
                НетПроблем = Ложь;
			КонецЕсли;
			
			ТЗ.Удалить(Сч);
			ТЗ.Удалить(Сч);
			ТекущееКоличество = ТекущееКоличество - 2;
		Иначе
			Сч = Сч + 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьЗавершенныеЗадания(ТаблицаВыгрузки)
	
	Если ТаблицаВыгрузки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонтрольнаяПроцедура", КонтрольнаяПроцедура);
	ПодготовитьВременнуюТаблицуСобытий(ТаблицаВыгрузки, Запрос);
	
	Выборка = ПолучитьЗавершенныеРегламентныеЗадания(Запрос);
	Пока Выборка.Следующий() Цикл
		
		УдалитьЗаписьРегистра(КонтрольнаяПроцедура, Выборка.НомерСеансаФоновогоЗадания, Выборка.ОбластьДанных);
		Если ВРег(Выборка.Событие) = ВРег(СобытиеЗавершеноСОшибками) Тогда
			СоздатьЗадачуПоРегламентномуЗаданию(
				Выборка.Сеанс, 
				Выборка.ИмяМетодаРегламентногоЗадания, 
				Выборка.ОбластьДанных,
				Ложь
			);
            НетПроблем = Ложь;

		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПодготовитьВременнуюТаблицуСобытий(ТЗ, Запрос)
	
	ТЗНовая = Новый ТаблицаЗначений;
	
	КвалификаторСтрока100 = Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная);
	КвалификаторЧисло20_0 = Новый КвалификаторыЧисла(20, 0, ДопустимыйЗнак.Неотрицательный);
	КвалификаторСтрока200 = Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная);
	КвалификаторДатаВремя = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
	ТЗНовая.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата", , , КвалификаторДатаВремя));
	ТЗНовая.Колонки.Добавить("Событие", Новый ОписаниеТипов("Строка", , КвалификаторСтрока100));
	ТЗНовая.Колонки.Добавить("Сеанс", Новый ОписаниеТипов("Число", КвалификаторЧисло20_0));
	ТЗНовая.Колонки.Добавить("ОбластьДанных", Новый ОписаниеТипов("Число", КвалификаторЧисло20_0));
	ТЗНовая.Колонки.Добавить("ИмяМетодаРегламентногоЗадания", Новый ОписаниеТипов("Строка", , КвалификаторСтрока200));
	
	Для Каждого СтрокаТЗ Из ТЗ Цикл
		
		Если ВРег(СтрокаТЗ.Событие) = ВРег(СобытиеСтарт) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТЗНовая = ТЗНовая.Добавить();
		СтрокаТЗНовая.Дата = СтрокаТЗ.Дата;
		СтрокаТЗНовая.Событие = СтрокаТЗ.Событие;
		СтрокаТЗНовая.Сеанс = СтрокаТЗ.Сеанс;
		СтрокаТЗНовая.ОбластьДанных = СтрокаТЗ.ОбластьДанных;
		СтрокаТЗНовая.ИмяМетодаРегламентногоЗадания = СтрокаТЗ.ИмяМетодаРегламентногоЗадания;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТЗ", ТЗНовая);
	
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЗ.Дата КАК Дата,
	|	ТЗ.Событие КАК Событие,
	|	ТЗ.Сеанс КАК Сеанс,
	|	ТЗ.ОбластьДанных КАК ОбластьДанных,
	|	ТЗ.ИмяМетодаРегламентногоЗадания КАК ИмяМетодаРегламентногоЗадания
	|ПОМЕСТИТЬ ВТ_События
	|ИЗ
	|	&ТЗ КАК ТЗ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сеанс,
	|	ОбластьДанных";
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПолучитьЗавершенныеРегламентныеЗадания(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВременаРегламентныхЗаданий.НомерСеансаФоновогоЗадания КАК НомерСеансаФоновогоЗадания,
	|	ВТ_События.ОбластьДанных КАК ОбластьДанных,
	|	ВТ_События.Событие КАК Событие,
	|	ВТ_События.Дата КАК Дата,
	|	ВТ_События.ИмяМетодаРегламентногоЗадания КАК ИмяМетодаРегламентногоЗадания
	|ИЗ
	|	РегистрСведений.ВременаРегламентныхЗаданий КАК ВременаРегламентныхЗаданий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_События КАК ВТ_События
	|		ПО ВременаРегламентныхЗаданий.НомерСеансаФоновогоЗадания = ВТ_События.Сеанс
	|			И (ВременаРегламентныхЗаданий.КонтрольнаяПроцедура = &КонтрольнаяПроцедура)
	|			И ВременаРегламентныхЗаданий.ОбластьДанных = ВТ_События.ОбластьДанных";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция ПолучитьПросроченныеРегламентныеЗадания(КонтрольнаяПроцедура)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонтрольнаяПроцедура", КонтрольнаяПроцедура);
	Запрос.УстановитьПараметр("ТекущееВремя", ТекущаяДата());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВременаРегламентныхЗаданий.НомерСеансаФоновогоЗадания КАК НомерСеансаФоновогоЗадания,
	|	ВременаРегламентныхЗаданий.ОбластьДанных КАК ОбластьДанных,
	|	ВременаРегламентныхЗаданий.ИмяМетодаРегламентногоЗадания КАК ИмяМетодаРегламентногоЗадания
	|ИЗ
	|	РегистрСведений.ВременаРегламентныхЗаданий КАК ВременаРегламентныхЗаданий
	|ГДЕ
	|	ВременаРегламентныхЗаданий.ТаймаутВыполнения < &ТекущееВремя
	|	И ВременаРегламентныхЗаданий.КонтрольнаяПроцедура = &КонтрольнаяПроцедура";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Процедура ЗафиксироватьНовыеНачалаРегламентныхЗаданий(КонтрольнаяПроцедура, ТЗ)
	
	ПараметрыОтбора = Новый Структура("Событие", СобытиеСтарт);
	СобытияСтарта = ТЗ.НайтиСтроки(ПараметрыОтбора);
	
	Если СобытияСтарта.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ВременаРегламентныхЗаданий.СоздатьНаборЗаписей();
	Для Каждого Событие Из СобытияСтарта Цикл
		Запись = НаборЗаписей.Добавить();
		Запись.КонтрольнаяПроцедура = КонтрольнаяПроцедура;
		Запись.НомерСеансаФоновогоЗадания = Событие.Сеанс;
		Запись.ОбластьДанных = Событие.ОбластьДанных;
		Запись.ТаймаутВыполнения = Событие.Дата + ДопустимаяДлительностьВыполнения;
		Запись.ОбластьДанных = Событие.ОбластьДанных;
		Запись.ИмяМетодаРегламентногоЗадания = Событие.ИмяМетодаРегламентногоЗадания;
	КонецЦикла;
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

Процедура УдалитьЗаписьРегистра(КонтрольнаяПроцедура, НомерСеансаФоновогоЗадания, ОбластьДанных)
	
	Запись = РегистрыСведений.ВременаРегламентныхЗаданий.СоздатьМенеджерЗаписи();
	Запись.КонтрольнаяПроцедура = КонтрольнаяПроцедура;
	Запись.НомерСеансаФоновогоЗадания = НомерСеансаФоновогоЗадания;
	Запись.ОбластьДанных = ОбластьДанных;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Запись.Удалить();
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьЗадачуПоРегламентномуЗаданию(
	НомерСеансаФоновогоЗадания, 
	ИмяМетодаРегламентногоЗадания, 
	ОбластьДанных,
	ЭтоТаймаут
)
    ИмяТипаЗадачи = ?(ЭтоТаймаут, 
		"КонтрольРегламентныхЗаданийТаймаут",
		"КонтрольРегламентныхЗаданийОшибка"	
	);
	ТипЗадачи = Справочники.ТипыЗадачКонтрольРегламентныхЗаданий[ИмяТипаЗадачи];
	ИмяСправки = ИмяТипаЗадачи;
	ОсновнойТекстПредупреждения = ?(ЭтоТаймаут,
		"Решить проблему незавершенных регламентных заданий",
		"Устранить ошибки выполнения регламентных заданий"
	);
	
	ДанныеПоЗадаче = "Номер сеанса: " + Строка(НомерСеансаФоновогоЗадания) + 
		"; Имя метода: " + Строка(ИмяМетодаРегламентногоЗадания) + "; Область данных: " + Строка(ОбластьДанных);
		
	
КонецПроцедуры	

#КонецЕсли

