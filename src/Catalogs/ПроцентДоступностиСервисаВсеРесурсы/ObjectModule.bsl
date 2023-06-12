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
	
	РезультатВыборки = ВыбратьИОбработатьДанные(
		ОпорнаяДата,
		НачальноеСмещение,
		ЧислоТочек,
		, 
		, 
		Шаг, 
		Истина
	);
	Данные = РезультатВыборки.Данные;
	
	Если Статистика <> Неопределено Тогда
		Если ВычислитьАгрегатныеЗначения Тогда
			Статистика = МониторингКлиентСервер.ВычислитьСредниеЗначения(Данные);
			Статистика.Вставить("ПоТочкам");
			ДлинаИнтервала = (ЧислоТочек - 1) * Шаг;
			//вычислим параметр "Текущее"
			Попытка
				ТекущееЗначение = Данные[Данные.Количество() - 1];
			Исключение
				Инфо = ИнформацияОбОшибке();
				Комментарий =
					"Описание = '" +Инфо.Описание + "', " +
					"ИмяМодуля = '" + Инфо.ИмяМодуля + "', " +
					"НомерСтроки = '" + Инфо.НомерСтроки + "', " +
					"ИсходнаяСтрока = '" + Инфо.ИсходнаяСтрока + "'.";
			
				ЗаписьЖурналаРегистрации(
					"Функция ПолучитьДанные(...)",
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники.ПроцентДоступностиСервисаВсеРесурсы.МодульОбъекта,
					,
					Комментарий);
				
				ТекущееЗначение = 0;
			КонецПопытки;
			Статистика.Вставить("Текущее", ТекущееЗначение);
			
			Статистика.Вставить("Всего", ВсегоВСтроку(
				ДлинаИнтервала,
				РезультатВыборки.ЧислоСекундНедоступности
			));
		КонецЕсли;
		
		Если ВычислитьГоризонтАктуальности Тогда
			Запрос = Новый Запрос;
			//ЗапросТекст = "ВЫБРАТЬ
			//|	МАКСИМУМ(ДоступностьИнформационныхБаз.Период) КАК Время
			//|ИЗ
			//|	РегистрСведений.ДоступностьИнформационныхБаз КАК ДоступностьИнформационныхБаз";
			
			ЗапросТекст = "ВЫБРАТЬ
			|	МАКСИМУМ(ДоступностьСайта.Период) КАК Время
			|ИЗ
			|	РегистрСведений.ДоступностьСайта КАК ДоступностьСайта";

			
			Запрос.Текст = ЗапросТекст;
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() И Выборка.Время <> Null Тогда
				Статистика.Вставить("Горизонт", Выборка.Время);
			Иначе
				Статистика.Вставить("Горизонт", Неопределено);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Функция ПолучитьДанныеОбнаруженияИнцидентов(ОпорнаяДата, Смещение, АгрегирующаяФункция, ФорматнаяСтрокаЗначения) Экспорт
    
    Статистика = Новый Структура;
    Шаг = Смещение/10;
    ПолучитьДанные(ОпорнаяДата - Смещение, 0, 11, Шаг, Статистика, Истина);
    
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

Функция ВсегоЗаПериод(Знач ДатаНачала, Знач ДатаОкончания) Экспорт
	
	РезультатВыборки = ВыбратьИОбработатьДанные(,,,ДатаНачала, ДатаОкончания, Неопределено);
	ЧислоСекундНедоступности = РезультатВыборки.ЧислоСекундНедоступности;
	
	Возврат ВсегоВСтроку(ДатаОкончания - ДатаНачала, ЧислоСекундНедоступности);
	
КонецФункции

Функция ВсегоВСтроку(ДлинаИнтервала, ЧислоСекундНедоступности) Экспорт
	
	СекундВИнтервалеУсреднения = МониторингСервер.СекундВИнтервалеУсреднения(ЭтотОбъект.ИнтервалУсреднения);
	
	Возврат Формат((ДлинаИнтервала - ЧислоСекундНедоступности) / СекундВИнтервалеУсреднения, "ЧН=;ЧДЦ=2")  + " / " 
		+ Формат(ДлинаИнтервала / СекундВИнтервалеУсреднения, "ЧН=;ЧДЦ=2")
		+ " " + МониторингСервер.ИнтервалУсредненияВРодительномПадеже(ЭтотОбъект.ИнтервалУсреднения);
	
КонецФункции

Функция ИдентификаторВариантаПоказателя() Экспорт
	ИД = МониторингСервер.ОбщаяЧастьИдентификатораВариантаПоказателя(
		ЭтотОбъект
	);
	
	//ЭтотОбъект.ИнформационныеБазы.ВыгрузитьКолонки("ИнформационнаяБаза");
	СервисыВТаблицу = ЭтотОбъект.Ресурсы.ВыгрузитьКолонки("Ресурс");

	Для Каждого СервисСтрока Из  ЭтотОбъект.Ресурсы Цикл
		ВремСтрока = СервисыВТаблицу.Добавить();
		ВремСтрока.Ресурс = СервисСтрока.Ресурс;
	КонецЦикла;
	
	СервисыВТаблицу.Сортировать("Ресурс");
	Для Каждого СервисСтрока Из СервисыВТаблицу Цикл
		ИД = ИД + "_" + СервисСтрока.Ресурс;
	КонецЦикла;
	
	Возврат ИД;
КонецФункции

Функция ВыбратьИОбработатьДанные(Знач ОпорнаяДата, Знач СмещениеОтОпорнойДаты, Знач ЧислоТочек, Знач ДатаНачала = Неопределено, Знач ДатаОкончания = Неопределено, Знач Шаг = Неопределено, ВычислитьВсегоМинутНедоступностиЗаПериод = Истина)
	
	РежимВычисленияЗамеров = Шаг <> Неопределено;
	РежимВычисленияВсего = ВычислитьВсегоМинутНедоступностиЗаПериод;
	
	СекундВИнтервалеУсреднения = МониторингСервер.СекундВИнтервалеУсреднения(ЭтотОбъект.ИнтервалУсреднения);
	
	Если ОпорнаяДата <> Неопределено Тогда
		ДатаНачалаСмещенная = ОпорнаяДата + 
			СмещениеОтОпорнойДаты * Шаг;
		ДатаОкончанияСмещенная = ОпорнаяДата + 
			(СмещениеОтОпорнойДаты + ЧислоТочек - 1) * Шаг;
		
	Иначе
		ДатаНачалаСмещенная = ДатаНачала;
		ДатаОкончанияСмещенная = ДатаОкончания;
	КонецЕсли;
	
	//СписокИнформационныхБаз = Новый Массив;
	//Для Каждого СтрокаБазы Из ЭтотОбъект.ИнформационныеБазы Цикл
	//	ИнформационнаяБаза = СтрокаБазы.ИнформационнаяБаза;
	//	Если СписокИнформационныхБаз.Найти(ИнформационнаяБаза) = Неопределено Тогда
	//		СписокИнформационныхБаз.Добавить(ИнформационнаяБаза);
	//	КонецЕсли;
	//КонецЦикла;
	
	СписокРесурсов = Новый Массив;
	Для Каждого СтрокаРесурсы Из ЭтотОбъект.Ресурсы Цикл
		Ресурс = СтрокаРесурсы.Ресурс;
		Если СписокРесурсов.Найти(Ресурс) = Неопределено Тогда
			СписокРесурсов.Добавить(Ресурс);
		КонецЕсли;
	КонецЦикла;

	
	РезультатВыборки = КонтрольПодключенийСервер.ВыборкаСостоянийРесурсовЗаПериод(
		ДатаНачалаСмещенная - ?(РежимВычисленияЗамеров, СекундВИнтервалеУсреднения, 0),
		ДатаОкончанияСмещенная,
		СписокРесурсов
	);
	
	ВыборкаСостояний = РезультатВыборки.ВыборкаСостояний;
	ВесаИнформационныхБаз = РезультатВыборки.ВесаРесурсов;
	
	Если РежимВычисленияЗамеров Тогда
		// Инициализируем блоки данных для расчета процента доступности
		БлокиДанных = Новый Массив;
		
		Если ОпорнаяДата <> Неопределено Тогда
			ИндексШага = 0;
			Пока ИндексШага < ЧислоТочек Цикл
				Дата = ОпорнаяДата + (СмещениеОтОпорнойДаты + ИндексШага) * Шаг;
				БлокиДанных.Добавить(Новый Структура(
					"Дата, ВремяДоступностиВБлоке",
					Дата,
					0
				));
				ИндексШага = ИндексШага + 1;
				
			КонецЦикла;
			
		Иначе
			Дата = ДатаНачалаСмещенная;
		Пока Дата <= ДатаОкончанияСмещенная Цикл
			БлокиДанных.Добавить(Новый Структура(
			"Дата, ВремяДоступностиВБлоке",
			Дата,
			0
			));
			Дата = Дата + Шаг;
		КонецЦикла;
			КонецЕсли;
		МинимальныйИндексБлока = 0;
		ЧислоБлоков = БлокиДанных.Количество();
	КонецЕсли;

	// Выборка упорядочена по возрастанию даты.
	// Начальные состояния выбираются, только если это состояния доступности.
	// Если данных по базе нет, то база считается недоступной.
	// Сервис недоступен, если недоступна хотя бы одна база.
	
	Если РежимВычисленияВсего Тогда
	ТекущаяДатаНачалаОбщейНедоступности = ДатаНачалаСмещенная;
	//ЧислоБаз = ЭтотОбъект.ИнформационныеБазы.Количество();
	ЧислоРесурсов = ЭтотОбъект.Ресурсы.Количество();
	НедоступныеРесурсыНаТекущийМомент = Новый Массив;
	Для Каждого Сервис Из ЭтотОбъект.Ресурсы Цикл
		НедоступныеРесурсыНаТекущийМомент.Добавить(Сервис.Ресурс);
	КонецЦикла;
	ЧислоСекундНедоступности = 0;
	КонецЕсли;
	
	Пока ВыборкаСостояний.Следующий() Цикл
		ДатаСобытия = ВыборкаСостояний.Время;
		ИБ = ВыборкаСостояний.Ресурс;
		Состояние = ВыборкаСостояний.ТекущееЗначение;
		
		Если РежимВычисленияЗамеров Тогда
			
			ИндексБлока = МинимальныйИндексБлока;
			Пока ИндексБлока < ЧислоБлоков Цикл
				Блок = БлокиДанных[ИндексБлока];
				ВерхняяГраницаБлока = Блок.Дата;
				
				Если ВерхняяГраницаБлока >= ДатаСобытия Тогда
					ДлительностьСостоянияВБлоке = ВерхняяГраницаБлока - ДатаСобытия;
					Если ДлительностьСостоянияВБлоке > СекундВИнтервалеУсреднения Тогда
						ДлительностьСостоянияВБлоке = СекундВИнтервалеУсреднения;
					КонецЕсли;
					
					Если НЕ ((БлокиДанных[0].Дата > ДатаСобытия) И (Состояние = 0)) Тогда 
						Блок.ВремяДоступностиВБлоке = Блок.ВремяДоступностиВБлоке + ?(Состояние = 0, -1, 1) * ДлительностьСостоянияВБлоке / ЧислоРесурсов;
					КонецЕсли;
					
				КонецЕсли;
				ИндексБлока = ИндексБлока + 1;
			КонецЦикла;
		КонецЕсли;
		
		Если РежимВычисленияВсего Тогда
			// Вычисление общего времени недоступности
			// Будем полагать, что сервис недоступен, если недоступна хотя бы одна 
			// информационная база в сервисе
			
			ИндексВСпискеНедоступныхРесурсов = НедоступныеРесурсыНаТекущийМомент.Найти(ИБ);
			Если Состояние = 0 Тогда
				// ресурс стал недоступен
				Если ИндексВСпискеНедоступныхРесурсов = Неопределено Тогда
					НедоступныеРесурсыНаТекущийМомент.Добавить(ИБ);
				КонецЕсли;
				Если ТекущаяДатаНачалаОбщейНедоступности = Неопределено Тогда
					//Если ИндексВСпискеНедоступныхРесурсов = Неопределено Тогда
					//НедоступныеРесурсыНаТекущийМомент = ?(ДатаСобытия < ДатаНачалаСмещенная, ДатаНачалаСмещенная, ДатаСобытия);
					ТекущаяДатаНачалаОбщейНедоступности = ?(ДатаСобытия < ДатаНачалаСмещенная, ДатаНачалаСмещенная, ДатаСобытия); 
				КонецЕсли;
			Иначе
				Если ИндексВСпискеНедоступныхРесурсов <> Неопределено Тогда
					НедоступныеРесурсыНаТекущийМомент.Удалить(ИндексВСпискеНедоступныхРесурсов);
				КонецЕсли;
				
				// Все базы вышли в режим доступности - сервис доступен
				Если ТекущаяДатаНачалаОбщейНедоступности <> Неопределено 
					И НедоступныеРесурсыНаТекущийМомент.Количество() = 0  
				Тогда
					Если ДатаСобытия > ДатаНачалаСмещенная Тогда
						ЧислоСекундНедоступности = ЧислоСекундНедоступности + (ДатаСобытия - ТекущаяДатаНачалаОбщейНедоступности);
					КонецЕсли;
					ТекущаяДатаНачалаОбщейНедоступности = Неопределено;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура();
	Если РежимВычисленияВсего Тогда
		Если НедоступныеРесурсыНаТекущийМомент.Количество() <> 0 Тогда
			ЧислоСекундНедоступности = ЧислоСекундНедоступности + (ДатаОкончанияСмещенная - ТекущаяДатаНачалаОбщейНедоступности);
		КонецЕсли;
		Результат.Вставить("ЧислоСекундНедоступности", ЧислоСекундНедоступности);
	КонецЕсли;
	
	Если РежимВычисленияЗамеров Тогда
		Данные = Новый Массив;
		Для Каждого Блок Из БлокиДанных Цикл
			Данные.Добавить(100 * Блок.ВремяДоступностиВБлоке / СекундВИнтервалеУсреднения);
		КонецЦикла;
		Результат.Вставить("Данные", Данные);
	КонецЕсли;
	
	Возврат Результат;
	
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
	ПараметрОповещения.АвтоМасштаб = Ложь;
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
	
	ОписаниеСервисов = МониторингСервер.РесурсыВСтроку(Ресурсы.ВыгрузитьКолонку("Ресурс"));
	
	НаименованиеВСтроку = ИдентификаторТипаПоказателя()
		+ " " + ИнтервалУсреднения
		+ ?(ПустаяСтрока(ОписаниеСервисов), "", " (" + ОписаниеСервисов + ")");
	
	Возврат НаименованиеВСтроку;
	
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
	
	ТаблицаДетальныхДанных = Новый ТаблицаЗначений();
	ТаблицаДетальныхДанных.Колонки.Добавить("ДатаТочки", Новый ОписаниеТипов("Дата"));
	ТаблицаДетальныхДанных.Колонки.Добавить("Максимальное", Новый ОписаниеТипов("Число"));
	ТаблицаДетальныхДанных.Колонки.Добавить("Минимальное", Новый ОписаниеТипов("Число"));
	ТаблицаДетальныхДанных.Колонки.Добавить("Значение", Новый ОписаниеТипов("Число"));
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	МИНИМУМ(ТаблицаПодготовительная.ДатаТочки) КАК ОпорнаяДата,
	|	КОЛИЧЕСТВО(ТаблицаПодготовительная.ДатаТочки) КАК ЧислоТочек,
	|	СРЕДНЕЕ(РАЗНОСТЬДАТ(ТаблицаПодготовительная.ДатаТочки, ТаблицаПодготовительная.ДатаТочкиСледующая, Секунда)) КАК Шаг
	|ИЗ
	|	ТаблицаПодготовительная КАК ТаблицаПодготовительная
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
			
		РезультатВыборки = ВыбратьИОбработатьДанные(
			Выборка.ОпорнаяДата,
			0,
			Выборка.ЧислоТочек,
			, 
			, 
			Цел(Выборка.Шаг),
			Истина
		);
		
		Данные = РезультатВыборки.Данные;
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ТаблицаПодготовительная.ДатаТочки КАК ДатаТочки
		|ИЗ
		|	ТаблицаПодготовительная КАК ТаблицаПодготовительная
		|ГДЕ
		|	ТаблицаПодготовительная.Показатель = &Показатель
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаТочки
		|";
		
		Запрос.УстановитьПараметр("Показатель", ЭтотОбъект.Ссылка);
		
		ВыборкаДаты = Запрос.Выполнить().Выбрать();
		Пока ВыборкаДаты.Следующий() Цикл
			
			НоваяСтрока = ТаблицаДетальныхДанных.Добавить();
			НоваяСтрока.ДатаТочки = ВыборкаДаты.ДатаТочки;
			
			Значение = 0;
			Попытка
				Значение = Данные[ТаблицаДетальныхДанных.Индекс(НоваяСтрока)];
			Исключение
			КонецПопытки;
			
			НоваяСтрока.Максимальное	= Значение;
			НоваяСтрока.Минимальное		= Значение;
			НоваяСтрока.Значение		= Значение;
			
		КонецЦикла;
	
	КонецЕсли;
	
	Возврат ТаблицаДетальныхДанных;
	
КонецФункции

#КонецОбласти

#КонецЕсли