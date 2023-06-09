#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	// Отключаем стандартный вывод отчета - будем выводить программно 
	СтандартнаяОбработка = Ложь;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();						// Получаем настройки отчета
	ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;  // Получаем пользовательские настройки
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;				// Создаем данные расшифровки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;				// Создаем компоновщик макета 
	
	// Инициализируем макет компоновки используя схему компоновки данных 
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ТЗнДанные = ПолучитьДанныеДляВывода(Настройки, ПользовательскиеНастройки);
	
	// Скомпонуем результат
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПараметрыПроцессораКомпоновки = Новый Структура("НаборДанныхДоступность", ТЗнДанные);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ПараметрыПроцессораКомпоновки, ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	
	//Проверим - есть ли автообновление
	//ПараметрАвтообновление = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Автообновление"));
	//ЭлементАвтообновление = ПользовательскиеНастройки.Элементы.Найти(ПараметрАвтообновление.ИдентификаторПользовательскойНастройки);	
	
	//Если ЭлементАвтообновление.Значение Тогда
		Область = ДокументРезультат.Область("R7:R10");
		Автообновление = 1;
	//Иначе
	//	Область = ДокументРезультат.Область("R7:R11");
	//	Автообновление = 0;
	//КонецЕсли;
	ДокументРезультат.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоВертикали); 

	ДокументРезультат.ФиксацияСверху = 9 + Автообновление + КоличествоЭлементовОтбор(Настройки.Отбор);
	ДокументРезультат.ФиксацияСлева = 2;
КонецПроцедуры

Функция КоличествоЭлементовОтбор(Отбор)
	Количество = 0;
	Для Каждого ТекЭлемент Из Отбор.Элементы Цикл
		Если ТекЭлемент.Использование Тогда
			Количество = Количество + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Количество;
КонецФункции

Функция ПолучитьДанныеДляВывода(Настройки, ПользовательскиеНастройки)
	UP = "UP";
	DOWN = "DOWN";
	UNKNOWN = "UNKNOWN";
	
	ПараметрПериодАнализа = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодАнализа"));
	ПараметрДатаНачала = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаНачала"));
	ПараметрДатаОкончания = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаОкончания"));
	ПараметрНачалоРабочегоДня = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоРабочегоДня"));
	ПараметрОкончаниеРабочегоДня = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОкончаниеРабочегоДня"));
	ПараметрСтатусИнформационнойБазы = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтатусИнформационнойБазы"));
	
	ЭлементПериодАнализа = ПользовательскиеНастройки.Элементы.Найти(ПараметрПериодАнализа.ИдентификаторПользовательскойНастройки);
	ЭлементДатаНачала = ПользовательскиеНастройки.Элементы.Найти(ПараметрДатаНачала.ИдентификаторПользовательскойНастройки);
	ЭлементДатаОкончания = ПользовательскиеНастройки.Элементы.Найти(ПараметрДатаОкончания.ИдентификаторПользовательскойНастройки);
	ЭлементНачалоРабочегоДня = ПользовательскиеНастройки.Элементы.Найти(ПараметрНачалоРабочегоДня.ИдентификаторПользовательскойНастройки);
	ЭлементОкончаниеРабочегоДня = ПользовательскиеНастройки.Элементы.Найти(ПараметрОкончаниеРабочегоДня.ИдентификаторПользовательскойНастройки);
	//ЭлементСтатусИнформационнойБазы = ПользовательскиеНастройки.Элементы.Найти(ПараметрСтатусИнформационнойБазы.ИдентификаторПользовательскойНастройки);
		
	ДатаОкончания = Дата(ЭлементДатаОкончания.Значение);
	ДатаНачала = Дата(ЭлементДатаНачала.Значение);
	НачалоРабочегоДня = Дата(ЭлементНачалоРабочегоДня.Значение);
	ОкончаниеРабочегоДня = Дата(ЭлементОкончаниеРабочегоДня.Значение);
	ИнформационнаяБаза = Неопределено;
	
	#Область Запрос
	Запрос = Новый Запрос;
	Запрос.Текст = "
	//Начало выборки во временную таблицу Доступность
	|ВЫБРАТЬ
	|	&ДатаНачала КАК Период,
	|	ВыборкаНачальная.Ресурс КАК Публикация,
	|	ВЫБОР РегСвДоступностьСайта.Доступность
	|		КОГДА 0 ТОГДА &UP
	|		КОГДА 1 ТОГДА &DOWN
	|	КОНЕЦ КАК Доступность
	|ПОМЕСТИТЬ
	|	ДоступностьВрТ
	|ИЗ
	|	(ВЫБРАТЬ
	|		Ресурс КАК Ресурс,
	|		МИНИМУМ(ПЕРИОД) КАК Период
	|	ИЗ
	|		РегистрСведений.ДоступностьСайта
	|	ГДЕ
	|		Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	СГРУППИРОВАТЬ ПО
	|		Ресурс
	|	) КАК ВыборкаНачальная
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ДоступностьСайта КАК РегСвДоступностьСайта
	|ПО
	|	РегСвДоступностьСайта.Ресурс = ВыборкаНачальная.Ресурс
	|	И РегСвДоступностьСайта.Период = ВыборкаНачальная.Период
	|
	|ОБЪЕДИНИТЬ ВСЕ	
	|
	|ВЫБРАТЬ
	|	РегСвДоступностьСайта.Период,
	|	РегСвДоступностьСайта.Ресурс,
	|	ВЫБОР РегСвДоступностьСайта.Доступность
	|		КОГДА 1 ТОГДА &UP
	|		КОГДА 0 ТОГДА &DOWN
	|	КОНЕЦ КАК Доступность
	|ИЗ
	|	РегистрСведений.ДоступностьСайта КАК РегСвДоступностьСайта
	|ГДЕ
	|	РегСвДоступностьСайта.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|;
	//Конец выборки во временную таблицу Доступность
	//==============================================
	//Начало выборки во временную таблицу ТекущееСостояние
	|ВЫБРАТЬ
	|	ИнформационнаяБаза КАК Публикация,
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(ДатаОкончания, &ТекущаяДата, СЕКУНДА) >= &ГлубинаВыборки ТОГДА &UNKNOWN
	|		ИНАЧЕ
	|			ВЫБОР
	|				КОГДА РезультатПодключения ТОГДА &UP
	|				КОГДА НЕ РезультатПодключения И РАЗНОСТЬДАТ(ДатаНачала, ДатаОкончания, СЕКУНДА) < &ГлубинаВыборки ТОГДА &UP
	|				ИНАЧЕ &DOWN
	|			КОНЕЦ
	|	КОНЕЦ КАК ДоступностьТекущееСостояние
	|ПОМЕСТИТЬ
	|	ТекущееСостояние
	|ИЗ
	|	РегистрСведений.КонтрольПодключенийТекущееСостояние
	|;
	//Конец выборки во временную таблицу ТекущееСостояние
	//========================================================
	//Начало выборки во временную таблицу КрайняяНедоступность
	|ВЫБРАТЬ
	|	Ресурс КАК Публикация,
	|	МАКСИМУМ(Период) КАК ДатаКрайняяНедоступность
	|ПОМЕСТИТЬ
	|	КрайняяНедоступность
	|ИЗ
	|	РегистрСведений.ДоступностьСайта
	|ГДЕ
	|	Доступность = 0
	|	И Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|СГРУППИРОВАТЬ ПО
	|	Ресурс
	|;
	//Конец выборки во временную таблицу КрайняяНедоступность
	//=========================================================================
	//Начало выборки в набор данных
	|ВЫБРАТЬ
	|	ДоступностьВрТ.Период КАК Период,
	|	ДоступностьВрТ.Публикация КАК Публикация,
	|	ДоступностьВрТ.Доступность КАК Доступность,
	|	ТекущееСостояниеВрТ.ДоступностьТекущееСостояние КАК ДоступностьТекущееСостояние,
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1,1,1), СЕКУНДА, РАЗНОСТЬДАТ(ISNULL(КрайняяНедоступностьВрТ.ДатаКрайняяНедоступность, &ДатаОкончания), &ДатаОкончания, СЕКУНДА)) КАК ДатаКрайняяНедоступность,
	|	ISNULL(КрайняяНедоступностьВрТ.ДатаКрайняяНедоступность, ДАТАВРЕМЯ(1,1,1)) КАК МоментКрайняяНедоступность
	|ИЗ
	|	ДоступностьВрТ
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	ТекущееСостояние КАК ТекущееСостояниеВрТ
	|ПО
	|	ТекущееСостояниеВрТ.Публикация = ДоступностьВрТ.Публикация
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	КрайняяНедоступность КАК КрайняяНедоступностьВрТ
	|ПО
	|	КрайняяНедоступностьВрТ.Публикация = ДоступностьВрТ.Публикация
	|УПОРЯДОЧИТЬ ПО
	|	ДоступностьВрТ.Публикация,
	|   ДоступностьВрТ.Период
	|;
	|";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	//Запрос.УстановитьПараметр("ИнфБаза", Справочники.ВидыОбъектовКонтроля.ИнформационнаяБаза);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("ГлубинаВыборки", Константы.КонтрольПодключенийДопустимаяНедоступность.Получить());
	//Запрос.УстановитьПараметр("КонтрольПодключений", Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Контроль подключений"));
	Запрос.УстановитьПараметр("UP", UP);
	Запрос.УстановитьПараметр("DOWN", DOWN);
	Запрос.УстановитьПараметр("UNKNOWN", UNKNOWN);
	
	//Если ЭлементСтатусИнформационнойБазы.Значение = "Активная" Тогда
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "{И СпрКП.Выполнять = ИСТИНА}", "И СпрКП.Выполнять = ИСТИНА");
	//Иначе
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "{И СпрКП.Выполнять = ИСТИНА}", "");
	//КонецЕсли;
	
	#КонецОбласти
	
	Результат = Запрос.Выполнить();
	ТЗнДанные = Результат.Выгрузить();
	Результат = Неопределено;
	
	ТЗнДанные.Колонки.Добавить("ВремяДоступности", Новый ОписаниеТипов(,,,Новый КвалификаторыЧисла(10, 0)));
	ТЗнДанные.Колонки.Добавить("ВремяНеДоступности", Новый ОписаниеТипов(,,,Новый КвалификаторыЧисла(10, 0)));
	ТЗнДанные.Колонки.Добавить("ВремяДоступностиРабочее", Новый ОписаниеТипов(,,,Новый КвалификаторыЧисла(10, 0)));
	ТЗнДанные.Колонки.Добавить("ВремяНеДоступностиРабочее", Новый ОписаниеТипов(,,,Новый КвалификаторыЧисла(10, 0)));
	ТЗнДанные.Колонки.Добавить("ОбщаяДлительностьРабочегоВремени", Новый ОписаниеТипов(,,,Новый КвалификаторыЧисла(15, 0)));
	ТЗнДанные.Колонки.Добавить("РазНедоступен", Новый ОписаниеТипов(,,,Новый КвалификаторыЧисла(10, 0)));
	ТЗнДанные.Колонки.Добавить("РазНедоступенРабочее", Новый ОписаниеТипов(,,,Новый КвалификаторыЧисла(10, 0)));
	
	
	ОбщаяДлительностьРабочегоВремени = ПолучитьДлительностьРабочегоВремени(ДатаНачала, ДатаОкончания, НачалоРабочегоДня, ОкончаниеРабочегоДня); 
	
	МаксИндекс = ТЗнДанные.Количество() - 1;
	Для ИндексСтроки = 0  По МаксИндекс Цикл
		ТекСтрока = ТЗнДанные[ИндексСтроки];
		ТекСтрока.ОбщаяДлительностьРабочегоВремени = ОбщаяДлительностьРабочегоВремени;
		
		ДлительностьПериода = 0;
		Если ИндексСтроки < МаксИндекс Тогда
			СледСтрока = ТЗнДанные[ИндексСтроки + 1];
			
			Если СледСтрока.Публикация <> ТекСтрока.Публикация Тогда
				ДлительностьПериода = (ДатаОкончания - ТекСтрока.Период);
			Иначе
				ДлительностьПериода = (СледСтрока.Период - ТекСтрока.Период);
			КонецЕсли;
		Иначе
			ДлительностьПериода = (ДатаОкончания - ТекСтрока.Период) * ?(ТекСтрока.Доступность = UP,1,0);
		КонецЕсли;
		
		ДлительностьПериодаРабочий = ПолучитьДлительностьРабочегоВремени(ТекСтрока.Период, ТекСтрока.Период + ДлительностьПериода, НачалоРабочегоДня, ОкончаниеРабочегоДня);
		
		Если ТекСтрока.Доступность <> UP Тогда
			ТекСтрока.ВремяДоступности = 0;
			ТекСтрока.ВремяНеДоступности = ДлительностьПериода;
			
			ТекСтрока.ВремяДоступностиРабочее = 0;
			ТекСтрока.ВремяНеДоступностиРабочее = ДлительностьПериодаРабочий;
			
			ТекСтрока.РазНедоступен = 1;
			Если ТекСтрока.ВремяНеДоступностиРабочее > 0 Тогда
				ТекСтрока.РазНедоступенРабочее = 1;
			КонецЕсли;
		Иначе
			ТекСтрока.ВремяДоступности = ДлительностьПериода;
			ТекСтрока.ВремяНеДоступности = 0;
			
			ТекСтрока.ВремяДоступностиРабочее = ДлительностьПериодаРабочий;
			ТекСтрока.ВремяНеДоступностиРабочее = 0;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат ТЗнДанные;	
КонецФункции

Функция ПолучитьДлительностьРабочегоВремени(Знач НачалоПериода, Знач ОкончаниеПериода, Знач НачалоРабочегоДня, Знач ОкончаниеРабочегоДня)
	ДлительностьПериодаРабочий = 0;

	Пока НачалоПериода < ОкончаниеПериода Цикл
		НачалоПериодаУказатель = Дата(1,1,1) + (НачалоПериода - НачалоДня(НачалоПериода));
		
		СмещениеНаНачалоРабочегоДня = НачалоРабочегоДня - НачалоПериодаУказатель;
		СмещениеНаОкончаниеПериода = ОкончаниеПериода - НачалоПериода;
		Если СмещениеНаОкончаниеПериода <= СмещениеНаНачалоРабочегоДня Тогда
			 НачалоПериода = НачалоПериода + СмещениеНаОкончаниеПериода;
			 НачалоПериодаУказатель = Дата(1,1,1) + (НачалоПериода - НачалоДня(НачалоПериода));
			 Продолжить;
		 Иначе
			 Если СмещениеНаНачалоРабочегоДня > 0 Тогда
				 НачалоПериода = НачалоПериода + СмещениеНаНачалоРабочегоДня;
				 НачалоПериодаУказатель = Дата(1,1,1) + (НачалоПериода - НачалоДня(НачалоПериода));
			 КонецЕсли;
		КонецЕсли;
		
		СмещениеНаОкончаниеРабочегоДня = ОкончаниеРабочегоДня - НачалоПериодаУказатель;
		СмещениеНаОкончаниеПериода = ОкончаниеПериода - НачалоПериода;
		
		Если СмещениеНаОкончаниеПериода <= СмещениеНаОкончаниеРабочегоДня Тогда
			ДлительностьПериодаРабочий = ДлительностьПериодаРабочий + СмещениеНаОкончаниеПериода;
			НачалоПериода = НачалоПериода + СмещениеНаОкончаниеПериода;
			НачалоПериодаУказатель = Дата(1,1,1) + (НачалоПериода - НачалоДня(НачалоПериода));
			Продолжить;
		Иначе
			Если СмещениеНаОкончаниеРабочегоДня > 0 Тогда
				ДлительностьПериодаРабочий = ДлительностьПериодаРабочий + СмещениеНаОкончаниеРабочегоДня;
				НачалоПериода = НачалоПериода + СмещениеНаОкончаниеРабочегоДня;
				НачалоПериодаУказатель = Дата(1,1,1) + (НачалоПериода - НачалоДня(НачалоПериода));
			КонецЕсли;
		КонецЕсли;
		
		СмещениеНаКонецДня = КонецДня(НачалоПериодаУказатель) - НачалоПериодаУказатель + 1;
		СмещениеНаОкончаниеПериода = ОкончаниеПериода - НачалоПериода;
		
		Если СмещениеНаКонецДня <= СмещениеНаОкончаниеПериода Тогда
			НачалоПериода = НачалоПериода + СмещениеНаКонецДня;
			НачалоПериодаУказатель = Дата(1,1,1) + (НачалоПериода - НачалоДня(НачалоПериода));
		Иначе
			НачалоПериода = НачалоПериода + СмещениеНаОкончаниеПериода;
			НачалоПериодаУказатель = Дата(1,1,1) + (НачалоПериода - НачалоДня(НачалоПериода));
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДлительностьПериодаРабочий;
КонецФункции

#КонецЕсли
